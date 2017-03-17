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

open class WBadge: UIView {
    open var badgeColor = UIColor(hex: 0x0094FF) { //blue
        didSet {
            setupUI()
        }
    }

    open var lockBadgeColor: Bool = true {
        didSet {
            badgeView.lockBackgroundColor = lockBadgeColor
            borderView.lockBackgroundColor = lockBadgeColor
            setupUI()
        }
    }
    
    open var countColor = UIColor.white {
        didSet {
            setupUI()
        }
    }

    open var borderColor = UIColor.clear {
        didSet {
            setupUI()
        }
    }
    
    open var borderWidth: CGFloat = 0 {
        didSet {
            setupUI()
        }
    }
    
    open var horizontalAlignment: xAlignment = .left {
        didSet {
            setupUI()
        }
    }

    open var verticalAlignment: yAlignment = .top {
        didSet {
            setupUI()
        }
    }

    // Will automatically hide the badge if less than 1
    open var automaticallyHide: Bool = true {
        didSet {
            isHidden = shouldHide()
        }
    }

    open var showValue: Bool = true {
        didSet {
            setupUI()
        }
    }

    open var count: Int = 0 {
        didSet {
            layoutIfNeeded()
            setupUI()
        }
    }

    open var widthPadding: CGFloat = 10.0 {
        didSet {
            setupUI()
        }
    }

    open var heightPadding: CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }

    open var font: UIFont = UIFont.boldSystemFont(ofSize: 12) {
        didSet {
            setupUI()
        }
    }

    open var fontSize: CGFloat = 12.0 {
        didSet {
            font = UIFont(name:font.fontName, size:fontSize)!
            setupUI()
        }
    }

    // Defaults to labelSize.height / 2 if not set
    open var cornerRadius: CGFloat? {
        didSet {
            setupUI()
        }
    }

    open func increment() {
        count = count + 1
    }

    open func decrement() {
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
        self.init(frame: CGRect.zero)

        self.count = count

        setupUI()
    }

    open func commonInit() {
        addSubview(borderView)
        addSubview(badgeView)
        badgeView.addSubview(countLabel)
    }

    fileprivate var labelSize: CGSize = CGSize.zero

    open func setupUI() {
        isHidden = shouldHide()

        setBadgeCount(count)

        badgeView.snp.remakeConstraints { (make) in
            switch horizontalAlignment {
            case .left:
                make.left.equalTo(0)
            case .center:
                make.centerX.equalTo(self)
            case .right:
                make.right.equalTo(0)
            }

            switch verticalAlignment {
            case .top:
                make.top.equalTo(0)
            case .center:
                make.centerY.equalTo(self)
            case .bottom:
                make.bottom.equalTo(0)
            }

            make.width.equalTo(sizeForBadge().width)
            make.height.equalTo(sizeForBadge().height)
        }

        borderView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(badgeView)
            make.centerY.equalTo(badgeView)
            make.width.equalTo(badgeView.snp.width).offset(borderWidth)
            make.height.equalTo(badgeView.snp.height).offset(borderWidth)
        }
        
        countLabel.snp.remakeConstraints { (make) in
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
        return CGSize(width: labelSize.width + widthPadding + borderWidth + (shouldShowValue() ? 0 : 1), height: labelSize.height + heightPadding + borderWidth)
    }

    internal func setBadgeCount(_ count: Int) {
        countLabel.text = (!showValue) ? " " : String(count)
        countLabel.textAlignment = .center
        countLabel.font = font
        countLabel.textColor = countColor
        countLabel.sizeToFit()

        // Layout to get frame
        layoutIfNeeded()
        labelSize = countLabel.frame.size
    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    // Adjusts the size of the enclosing view (user should not modify the height/width)
    open override var intrinsicContentSize : CGSize {
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
            if (lockBackgroundColor && UIColor.clear.isEqual(backgroundColor)) {
                backgroundColor = oldValue
            }
        }
    }	
}
