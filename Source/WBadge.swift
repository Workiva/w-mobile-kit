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

    internal var countLabel = UILabel()

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
        setBadgeCount(count)

        badgeView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(0).offset(sizeForBadge().width)
            make.height.equalTo(0).offset(sizeForBadge().height)
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
        badgeView.backgroundColor = badgeColor
    }

    internal func sizeForBadge() -> CGSize {
        return CGSizeMake(labelSize.width+widthPadding, labelSize.height+heightPadding)
    }

    internal func setBadgeCount(count: Int) {
        let countString = String(count)

        let attributedString = NSMutableAttributedString(string: countString)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.6), range: NSRange(location: 0, length: countString.characters.count))

        countLabel.attributedText = attributedString
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.font = font
        countLabel.textColor = countColor
        countLabel.sizeToFit()

        // Layout to get frame
        layoutIfNeeded()
        labelSize = countLabel.frame.size
    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    // Adjusts the size of the enclosing view (user should not modify the height/width)
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: sizeForBadge().width, height: sizeForBadge().height)
    }
}
