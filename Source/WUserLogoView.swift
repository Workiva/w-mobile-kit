//
//  WUserLogoView.swift
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import UIKit
import SDWebImage

public enum Shape {
    case Circle, Square
}

public enum Type {
    case Outline, Filled
}

open class WUserLogoView: UIView {
    open var initialsLimit = 3 {
        didSet {
            setupUI()
        }
    }
    open var initialsLabel = UILabel()
    internal var shapeLayer = CAShapeLayer()
    internal var profileImageView = UIImageView()

    internal var mappedColor = UIColor.clear

    // Overrides the mapped color
    open var color: UIColor? {
        didSet {
            updateMappedColor()
        }
    }

    open var name: String? {
        didSet {
            initials = name?.initials(initialsLimit)
        }
    }

    open var initials: String? {
        didSet {
            setupUI()
        }
    }

    open var lineWidth: CGFloat = 1.0 {
        didSet {
            setupUI()
        }
    }

    open var shape: Shape = .Circle {
        didSet {
            setupUI()
        }
    }

    open var type: Type = .Outline {
        didSet {
            setupUI()
        }
    }

    open var cornerRadius: CGFloat = 3 {
        didSet {
            setupUI()
        }
    }

    open override var bounds: CGRect {
        didSet {
            if (!subviews.contains(initialsLabel)) {
                commonInit()
            }

            setupUI()
        }
    }

    fileprivate var image: UIImage? {
        didSet {
            setupUIMainThread()
        }
    }
    
    open var imageURL: String? {
        didSet {
            if (imageURL != nil) {
                // Only update when necessary or when the URL has changed
                if (image == nil || imageURL != oldValue) {
                    if let checkedUrl = URL(string: imageURL!) {
                        downloadImage(checkedUrl)
                    }
                }
            } else {
                image = nil
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init(name: String) {
        self.init(frame: CGRect.zero)

        self.name = name
    }

    open func commonInit() {
        isOpaque = false

        addSubview(initialsLabel)
        addSubview(profileImageView)

        layer.addSublayer(shapeLayer)
    }

    fileprivate func setupUIMainThread() {
        DispatchQueue.main.async {
            self.setupUI()
        }
    }

    open func setupUI() {
        if (frame.equalTo(CGRect.zero)) {
            return
        }

        initialsLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(self).multipliedBy(0.8)
        }

        profileImageView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-2) // Prevents image from bleeding outside circle
            make.width.equalTo(self).offset(-2)
        }

        updateMappedColor()

        layoutIfNeeded()

        if (image == nil) {
            setupInitials()
        } else {
            setupImage()
        }

        setupShape()
    }

    fileprivate func setupInitials() {
        initialsLabel.isHidden = false
        profileImageView.isHidden = true

        let spacing = max(frame.size.width, 30) / 30 - 1
        let attributedString = NSMutableAttributedString(string: initials!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(spacing), range: NSRange(location: 0, length: max(initials!.characters.count - 1, 0)))

        initialsLabel.attributedText = attributedString
        initialsLabel.textAlignment = NSTextAlignment.center
        initialsLabel.adjustsFontSizeToFitWidth = true
        switch type {
        case .Outline:
            initialsLabel.textColor = mappedColor
            initialsLabel.font = UIFont.systemFont(ofSize: frame.width / 2.5)
        case .Filled:
            initialsLabel.textColor = UIColor.white
            initialsLabel.font = UIFont.boldSystemFont(ofSize: frame.width / 2.5)
        }
        bringSubview(toFront: initialsLabel)
    }

    fileprivate func setupImage() {
        if (image != nil) {
            initialsLabel.isHidden = true
            profileImageView.isHidden = false

            switch shape {
            case .Circle:
                profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            case .Square:
                profileImageView.layer.cornerRadius = cornerRadius
            }
            profileImageView.clipsToBounds = true
            profileImageView.contentMode = .scaleAspectFill
        }
    }

    fileprivate func setupShape() {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        var path: UIBezierPath!

        switch shape {
        case .Circle:
            path = UIBezierPath(arcCenter: center, radius: frame.width / 2 - 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        case .Square:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: cornerRadius)
        }

        shapeLayer.path = path.cgPath
        switch type {
        case .Outline:
            shapeLayer.fillColor = UIColor.clear.cgColor
        case.Filled:
            shapeLayer.fillColor = mappedColor.cgColor
        }
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = mappedColor.cgColor
    }

    fileprivate func updateMappedColor() {
        if (image != nil) {
            // Color for when an image is in use
            mappedColor = WUserLogoView.mapImageDataToColor(image)
        } else if (name != nil && name != "") {
            // Use user provided color if populated. Otherwise use mapped color for name
            mappedColor = (color != nil) ? color! : WUserLogoView.mapNameToColor(name!)

            // Use user provided initials if populated
            if (initials == nil) {
                initials = name!.initials(initialsLimit)
            }
        } else {
            // Use "?" if name is not set
            if (initials != "?") {
                initials = "?"
            }
            mappedColor = .gray
        }
    }

    // Can be overridden for differnt mappings
    open class func mapNameToColor(_ name: String) -> UIColor {
        // CRC32 decimal
        let colorMapValue = name.crc32int() % 5

        switch colorMapValue {
        case 0:
            return UIColor(hex: 0x42AD48) // Green
        case 1:
            return UIColor(hex: 0xA71B19) // Red
        case 2:
            return UIColor(hex: 0x026DCE) // Blue
        case 3:
            return UIColor(hex: 0x813296) // Purple
        default:
            return UIColor(hex: 0xF26C21) // Orange
        }
    }

    // Can be overridden for differnt mappings
    open class func mapImageDataToColor(_ image: UIImage?) -> UIColor {
        return UIColor(hex: 0xE3E3E3) // Gray89
    }

    fileprivate func getDataFromUrl(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            completion(data, response, error)
//            }).resume()
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            completion(data, response, error)
        }.resume()
    }

    fileprivate func downloadImage(_ url: URL){
        profileImageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
            if (error == nil) {
                self.image = image
            } else {
                self.image = nil
            }
        })
    }
}
