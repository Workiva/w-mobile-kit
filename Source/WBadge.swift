//
//  WBadge.swift
//  WMobileKit

import Foundation
import UIKit

public class WBadge: UIView {
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

    public var horizontalAlignment: xAlignment = .Left {
        didSet {
            setupUI()
        }
    }

    public var verticalAlignment: yAlignment = .Top {
        didSet {
            setupUI()
        }
    }

    // Will automatically hide the badge if less than 1
    public var automaticallyHide: Bool = true {
        didSet {
            hidden = shouldHide()
        }
    }

    public var count: Int = 0 {
        didSet {
            setupUI()
        }
    }

    public var widthPadding: CGFloat = 10.0 {
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

    // Defaults to labelSize.height / 2 if not set
    public var cornerRadius: CGFloat? {
        didSet {
            setupUI()
        }
    }

    public func increment() {
        count = count + 1
    }

    public func decrement() {
        count = count - 1
    }

    internal var badgeView = UIView()

    internal var countLabel = UILabel()

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
        hidden = shouldHide()

        setBadgeCount(count)

        badgeView.snp_remakeConstraints { (make) in
            switch horizontalAlignment {
            case .Left:
                make.left.equalTo(0)
            case .Center:
                make.centerX.equalTo(self)
            case .Right:
                make.right.equalTo(0)
            }

            switch verticalAlignment {
            case .Top:
                make.top.equalTo(0)
            case .Center:
                make.centerY.equalTo(self)
            case .Bottom:
                make.bottom.equalTo(0)
            }

            make.width.equalTo(sizeForBadge().width)
            make.height.equalTo(sizeForBadge().height)
        }

        countLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(badgeView)
            make.centerY.equalTo(badgeView)
            make.width.equalTo(labelSize.width)
            make.height.equalTo(labelSize.height)
        }

        layoutIfNeeded()
        invalidateIntrinsicContentSize()

        badgeView.clipsToBounds = true
        badgeView.layer.cornerRadius = (cornerRadius != nil) ? cornerRadius! : (labelSize.height / 2)
        badgeView.backgroundColor = badgeColor
    }

    internal func shouldHide() -> Bool {
        return ((count < 1) && automaticallyHide) ? true : false
    }

    internal func sizeForBadge() -> CGSize {
        return CGSizeMake(labelSize.width+widthPadding, labelSize.height+heightPadding)
    }

    internal func setBadgeCount(count: Int) {
        countLabel.text = String(count)
        countLabel.textAlignment = .Center
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
