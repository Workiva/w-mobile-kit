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

    public var fontSize: CGFloat = 12 {
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

    public var badgeColor = UIColor(hex: 0x0094FF) {
        didSet {
            setupUI()
        }
    }

    public var countColor = UIColor.whiteColor() {
        didSet {
            setupUI()
        }
    }

    public override var bounds: CGRect {
        didSet {
            if (!subviews.contains(countLabel)) {
                commonInit()
            }

            setupUI()
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

    public convenience init(_ count: Int) {
        self.init(frame: CGRectZero)

        self.count = count
    }

    public func commonInit() {
        addSubview(badgeView)
        badgeView.addSubview(countLabel)
    }

    public func setupUI() {
        let countString = String(count)

        let attributedString = NSMutableAttributedString(string: countString)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.6), range: NSRange(location: 0, length: countString.characters.count))

        countLabel.attributedText = attributedString
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.font = font
//        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.textColor = countColor

        let size = sizeForString(countString)

//        let newString: NSString = countString as NSString
//        let size: CGSize = newString.sizeWithAttributes([NSFontAttributeName: font])

//        CGSize textStringSize = [countString sizeWithFont:font
//            constrainedToSize:9999
//            lineBreakMode:self.dateLabel.lineBreakMode];

        badgeView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
//            make.width.equalTo(size.width).offset(padding) // height of text
//            make.height.equalTo(size.height).offset(padding) // width of text
            make.width.equalTo(0).offset(size.width+widthPadding)
            make.height.equalTo(0).offset(size.height+heightPadding)
//            make.width.equalTo(size.width)
//            make.height.equalTo(size.height)

        }

        layoutIfNeeded()
        layoutSubviews()
        layoutIfNeeded()

        countLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(badgeView)
            make.centerY.equalTo(badgeView)
//            make.width.equalTo(size.width)
//            make.height.equalTo(size.height)
//            make.width.equalTo(size.width).offset(padding) // height of text
//            make.height.equalTo(size.height).offset(padding) // width of text
            make.width.equalTo(0).offset(size.width)
            make.height.equalTo(0).offset(size.height)
        }

//        clipsToBounds = true
//
//        layer.cornerRadius = (cornerRadius != nil) ? cornerRadius! : (frame.size.height / 2)
//        backgroundColor = badgeColor

        badgeView.clipsToBounds = true
        badgeView.layer.cornerRadius = (cornerRadius != nil) ? cornerRadius! : (frame.size.height / 2)
        badgeView.backgroundColor = badgeColor

        layoutIfNeeded()
        layoutSubviews()
        layoutIfNeeded()

    }

    func sizeForString(string: String) -> CGSize {
//        return (string as NSString).sizeWithAttributes([NSFontAttributeName: font])

        return (string as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize+3)])

//        return size

//        return CGSizeMake(1, 1)
    }
}
