//
//  WUserLogoView.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
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
import CryptoSwift

public class WUserLogoView: UIView {
    public var initialsLimit = 3 {
        didSet {
            setupUI()
        }
    }
    public var initialsLabel = UILabel()
    internal var circleLayer = CAShapeLayer()
    internal var profileImageView = UIImageView()

    internal var mappedColor = UIColor.clearColor()

    // Overrides the mapped color
    public var color: UIColor? {
        didSet {
            updateMappedColor()
        }
    }

    public var name: String? {
        didSet {
            initials = name?.initials(initialsLimit)
        }
    }

    public var initials: String? {
        didSet {
            setupUI()
        }
    }

    public var lineWidth: CGFloat = 1.0 {
        didSet {
            setupUI()
        }
    }

    public override var bounds: CGRect {
        didSet {
            if (!subviews.contains(initialsLabel)) {
                commonInit()
            }

            setupUI()
        }
    }

    internal var imageData: NSData? {
        didSet {
            setupUIMainThread()
        }
    }

    public var imageURL: String? {
        didSet {
            if (imageURL != nil) {
                // Only update when necessary or when the URL has changed
                if (imageData == nil || imageURL != oldValue) {
                    if let checkedUrl = NSURL(string: imageURL!) {
                        downloadImage(checkedUrl)
                    }
                }
            } else {
                imageData = nil
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

    public convenience init(_ name: String) {
        self.init(frame: CGRectZero)

        self.name = name
    }

    public func commonInit() {
        opaque = false

        addSubview(initialsLabel)
        addSubview(profileImageView)

        layer.addSublayer(circleLayer)
    }

    private func setupUIMainThread() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setupUI()
        }
    }

    public func setupUI() {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            return
        }

        initialsLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(self).multipliedBy(0.8)
        }

        profileImageView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-1).priorityHigh()
            make.width.equalTo(self).offset(-1).priorityHigh()
        }

        updateMappedColor()

        layoutIfNeeded()

        if (imageData == nil) {
            setupInitials()
        } else {
            setupImage()
        }

        setupCircle()
    }

    private func setupInitials() {
        initialsLabel.hidden = false
        profileImageView.hidden = true

        let spacing = max(frame.size.width, 30) / 30 - 1
        let attributedString = NSMutableAttributedString(string: initials!)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(spacing), range: NSRange(location: 0, length: max(initials!.characters.count - 1, 0)))

        initialsLabel.attributedText = attributedString
        initialsLabel.textAlignment = NSTextAlignment.Center
        initialsLabel.font = UIFont.systemFontOfSize(frame.width / 2.5)
        initialsLabel.adjustsFontSizeToFitWidth = true
        initialsLabel.textColor = mappedColor
    }

    private func setupImage() {
        if let profileImageData = imageData {
            initialsLabel.hidden = true
            profileImageView.hidden = false

            profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView.clipsToBounds = true
            profileImageView.contentMode = .ScaleAspectFill

            profileImageView.image = UIImage(data: profileImageData)
        }
    }

    private func setupCircle() {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: frame.width / 2 - 1, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)

        circleLayer.path = path.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = mappedColor.CGColor
    }

    private func updateMappedColor() {
        if (imageData != nil) {
            // Color for when an image is in use
            mappedColor = WUserLogoView.mapImageDataToColor(imageData!)
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
            mappedColor = .grayColor()
        }
    }

    // Can be overridden for differnt mappings
    public class func mapNameToColor(name: String) -> UIColor {
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
    public class func mapImageDataToColor(imageData: NSData) -> UIColor {
        return UIColor(hex: 0xE3E3E3) // Gray89
    }

    private func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    private func downloadImage(url: NSURL){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.getDataFromUrl(url) { (data, response, error) in
                self.imageData = data

                if (self.imageData == nil) {
                    // The image data failed to load,
                    // so clear the URL as well
                    self.imageURL = nil
                }
            }
        }
    }
}
