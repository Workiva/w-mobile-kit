//
//  WBadge.swift
//  WMobileKit

import Foundation
import UIKit

public class WBadge: UIView {
    public var count: Int = 0 {
        didSet {
            setupUI()
        }
    }

    public var widthPadding: CGFloat = 20.0 {
        didSet {
            setupUI()
        }
    }

    public var heightPadding: CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }

    public var font: UIFont = UIFont.boldSystemFontOfSize(12) {
        didSet {
            setupUI()
        }
    }

    public var fontSize: CGFloat = 12.0 {
        didSet {
            font = UIFont(name:font.fontName, size:fontSize)!
            setupUI()
        }
    }

    public var cornerRadius: CGFloat? {
        didSet {
            setupUI()
        }
    }

    internal var badgeView = UIView()

    public var countLabel = UILabel()

    public var badgeColor = UIColor(hex: 0x0094FF) { //blue
        didSet {
            setupUI()
        }
    }

    public var countColor = UIColor.whiteColor() {
        didSet {
            setupUI()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        setupUI()
    }

    public convenience init(_ count: Int) {
        self.init(frame: CGRectZero)

        self.count = count

        setupUI()
    }

    public func commonInit() {
        addSubview(badgeView)
        badgeView.addSubview(countLabel)
    }

    private var labelSize: CGSize = CGSizeZero

    public func setupUI() {
        let countString = String(count)

        let attributedString = NSMutableAttributedString(string: countString)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.6), range: NSRange(location: 0, length: countString.characters.count))

        countLabel.attributedText = attributedString
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.font = font
        countLabel.textColor = countColor

        countLabel.sizeToFit()
        layoutIfNeeded()

        labelSize = countLabel.frame.size

//        let size = sizeForString(countString)

        badgeView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(0).offset(labelSize.width+widthPadding)
            make.height.equalTo(0).offset(labelSize.height+heightPadding)
        }

        countLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(badgeView)
            make.centerY.equalTo(badgeView)
            make.width.equalTo(0).offset(labelSize.width)
            make.height.equalTo(0).offset(labelSize.height)
        }

        layoutIfNeeded()
        invalidateIntrinsicContentSize()

        badgeView.clipsToBounds = true
        badgeView.layer.cornerRadius = (cornerRadius != nil) ? cornerRadius! : (labelSize.height / 2)
//        badgeView.layer.cornerRadius = 10
        badgeView.backgroundColor = badgeColor
    }

//    func sizeForString(string: String) -> CGSize {
//        return (string as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize + 3)])
//    }
//
//    func sizeForBadge() -> CGSize {
//        return sizeForString(String(count))
//    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    public override func intrinsicContentSize() -> CGSize {
//        let size = sizeForBadge()
        return CGSize(width: labelSize.width+widthPadding, height: labelSize.height+heightPadding)
    }
}
