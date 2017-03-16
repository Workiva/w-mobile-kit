//
//  WBadge.swift
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

public class WBadge: UIView {
    public var badgeColor = UIColor(hex: 0x0094FF) { //blue
        didSet {
            setupUI()
        }
    }

    public var lockBadgeColor: Bool = true {
        didSet {
            badgeView.lockBackgroundColor = lockBadgeColor
            borderView.lockBackgroundColor = lockBadgeColor
            setupUI()
        }
    }
    
    public var countColor = UIColor.whiteColor() {
        didSet {
            setupUI()
        }
    }

    public var borderColor = UIColor.clearColor() {
        didSet {
            setupUI()
        }
    }
    
    public var borderWidth: CGFloat = 0 {
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

    public var showValue: Bool = true {
        didSet {
            setupUI()
        }
    }

    public var count: Int = 0 {
        didSet {
            layoutIfNeeded()
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

    internal var borderView = WLockBackgroundView()
    
    internal var badgeView = WLockBackgroundView()

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
        addSubview(borderView)
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

        borderView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(badgeView)
            make.centerY.equalTo(badgeView)
            make.width.equalTo(badgeView.snp_width).offset(borderWidth)
            make.height.equalTo(badgeView.snp_height).offset(borderWidth)
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

        borderView.clipsToBounds = true
        borderView.layer.cornerRadius = badgeView.layer.cornerRadius
        borderView.backgroundColor = borderColor
    }
	
    internal func shouldHide() -> Bool {
        return ((count < 1) && automaticallyHide)
    }

    internal func shouldShowValue() -> Bool {
        return (!shouldHide() && showValue)
    }

    internal func sizeForBadge() -> CGSize {
        return CGSizeMake(labelSize.width + widthPadding + borderWidth + (shouldShowValue() ? 0 : 1), labelSize.height + heightPadding + borderWidth)
    }

    internal func setBadgeCount(count: Int) {
        countLabel.text = (!showValue) ? " " : String(count)
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

// This class allows a view to keep its background color when in a UITableViewCell
// that has been selected. In this case, the OS clears the background color of
// all views in the cell and restores them upon deselection.
internal class WLockBackgroundView: UIView {
    var lockBackgroundColor = true

    override var backgroundColor: UIColor? {
        didSet {
            if (lockBackgroundColor && UIColor.clearColor().isEqual(backgroundColor)) {
                backgroundColor = oldValue
            }
        }
    }	
}
