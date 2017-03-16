//
//  WBanner.swift
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
import SnapKit

@objc public protocol WBannerViewDelegate {
    optional func bannerWasTapped(sender: UITapGestureRecognizer)
    optional func bannerDidHide(bannerView: WBannerView)
}

public enum WBannerHideOptions {
    case NeverDismisses, DismissOnTap, DismissesAfterTime
}

public enum WBannerPlacementOptions {
    case Top, Bottom
}

let BANNER_DEFAULT_HEIGHT = 68
let BANNER_DEFAULT_SHOW_DURATION = 2.0
let BANNER_DEFAULT_ANIMATION_DURATION = 0.3
let BANNER_DEFAULT_TOP_PADDING = 12
let BANNER_DEFAULT_BOTTOM_PADDING = 12
let BANNER_DEFAULT_LEFT_PADDING = 16
let BANNER_DEFAULT_RIGHT_PADDING = 16
let BANNER_RIGHT_ICON_IMAGE_VIEW_PADDING = 8

let BANNER_DEFAULT_BODY_NUMBER_OF_LINES = 2

public class WBannerView: UIView {
    // Public API
    public weak var delegate: WBannerViewDelegate?

    public var rootView: UIView?

    // If 0 or less, options change to dismiss on tap
    public var showDuration: NSTimeInterval = BANNER_DEFAULT_SHOW_DURATION {
        didSet {
            hideOptions = showDuration > 0 ? .DismissesAfterTime : .DismissOnTap
        }
    }

    public var hideOptions: WBannerHideOptions = .DismissesAfterTime
    public var placement: WBannerPlacementOptions = .Bottom
    public var animationDuration = BANNER_DEFAULT_ANIMATION_DURATION
    public var height = BANNER_DEFAULT_HEIGHT
    public var sidePadding: CGFloat = 0

    public var titleMessage = "" {
        didSet {
            titleMessageLabel.text = titleMessage
        }
    }
    public var bodyMessage = "" {
        didSet {
            bodyMessageLabel.text = bodyMessage
        }
    }

    public var titleIcon: UIImage? {
        didSet {
            titleIconImageView.image = titleIcon
        }
    }

    public var rightIcon: UIImage? {
        didSet {
            rightIconImageView.image = rightIcon
        }
    }

    public var bannerColor: UIColor = .blackColor() {
        didSet {
            backgroundView.backgroundColor = bannerColor
        }
    }

    public var bannerAlpha: CGFloat = 1.0 {
        didSet {
            backgroundView.alpha = bannerAlpha
            rightIconImageView.alpha = bannerAlpha
        }
    }

    /// Used to manually change the number of lines for the body.
    var bodyNumberOfLines: Int = BANNER_DEFAULT_BODY_NUMBER_OF_LINES {
        didSet {
            if (bodyNumberOfLines < 1) {
                bodyNumberOfLines = 1
            } else {
                bodyMessageLabel.numberOfLines = bodyNumberOfLines

                setupUI()
            }
        }
    }

    public var titleMessageLabel = UILabel()
    public var bodyMessageLabel = WLabel()
    public var titleIconImageView = UIImageView()
    public var rightIconImageView = UIImageView()
    public var backgroundView = UIView()

    // Private API
    internal var showTimer: NSTimer?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init(rootView: UIView) {
        self.init(frame: CGRectZero)

        self.rootView = rootView
    }

    public convenience init(rootView: UIView, titleMessage: String, titleIcon: UIImage? = nil, bodyMessage: String, rightIcon: UIImage? = nil, bannerColor: UIColor = .blackColor(), bannerAlpha: CGFloat = 1.0) {
        self.init(frame: CGRectZero)

        self.rootView = rootView
        self.titleMessage = titleMessage
        self.titleIcon = titleIcon
        self.bodyMessage = bodyMessage
        self.bannerColor = bannerColor
        self.bannerAlpha = bannerAlpha
        self.rightIcon = rightIcon
    }

    private func commonInit() {
        addSubview(backgroundView)
        addSubview(titleMessageLabel)
        addSubview(titleIconImageView)
        addSubview(bodyMessageLabel)
        bodyMessageLabel.delegate = self
        addSubview(rightIconImageView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WBannerViewDelegate.bannerWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be
        // overwritten by custom user values
        titleMessageLabel.numberOfLines = 1
        titleMessageLabel.textAlignment = .Left
        titleMessageLabel.font = UIFont.boldSystemFontOfSize(15)
        titleMessageLabel.textColor = .whiteColor()

        bodyMessageLabel.numberOfLines = bodyNumberOfLines
        bodyMessageLabel.textAlignment = .Left
        bodyMessageLabel.font = UIFont.systemFontOfSize(12)
        bodyMessageLabel.textColor = .whiteColor()
    }

    public func setupUI() {
        // Do not set any defaults here as they will overwrite any custom
        // values when the banner is shown.
        // Values set by variables should still be set.
        backgroundView.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        backgroundView.backgroundColor = bannerColor

        titleIconImageView.image = titleIcon
        if (titleIconImageView.image != nil) {
            titleIconImageView.snp_remakeConstraints { (make) in
                make.left.equalTo(self).offset(BANNER_DEFAULT_LEFT_PADDING)
                make.top.equalTo(self).offset(verticalPaddingForNumberOfLines(bodyNumberOfLines))
                make.height.equalTo(15)
                make.width.equalTo(15)
            }
        } else {
            // Hide if not populated
            titleIconImageView.snp_remakeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
        }

        rightIconImageView.image = rightIcon
        if (rightIconImageView.image != nil) {
            rightIconImageView.snp_remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
                make.height.equalTo(16)
                make.width.equalTo(16)
            }
        } else {
            // Hide if not populated
            rightIconImageView.snp_remakeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
        }

        titleMessageLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(self).offset(verticalPaddingForNumberOfLines(bodyNumberOfLines))
            make.height.equalTo(15)

            if (titleIconImageView.image != nil) {
                make.left.equalTo(titleIconImageView.snp_right).offset(6)
            } else {
                make.left.equalTo(self).offset(BANNER_DEFAULT_RIGHT_PADDING)
            }

            if (rightIconImageView.image != nil) {
                make.right.equalTo(rightIconImageView.snp_left).offset(-BANNER_RIGHT_ICON_IMAGE_VIEW_PADDING)
            } else {
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
            }
        }
        titleMessageLabel.text = titleMessage

        bodyMessageLabel.snp_remakeConstraints { (make) in
            if (bodyNumberOfLines <= 1) {
                make.top.equalTo(titleMessageLabel.snp_bottom).offset(7)
            } else {
                make.top.equalTo(titleMessageLabel.snp_bottom).offset(4)
            }

            make.bottom.equalTo(self).offset(-verticalPaddingForNumberOfLines(bodyNumberOfLines))
            make.left.equalTo(self).offset(BANNER_DEFAULT_LEFT_PADDING)

            if (rightIconImageView.image != nil) {
                make.right.equalTo(rightIconImageView.snp_left).offset(-BANNER_RIGHT_ICON_IMAGE_VIEW_PADDING)
            } else {
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
            }
        }
        bodyMessageLabel.text = bodyMessage

        backgroundView.alpha = bannerAlpha
        rightIconImageView.alpha = bannerAlpha

        layoutIfNeeded()
    }

    private func verticalPaddingForNumberOfLines(numberOfLines: Int) -> CGFloat {
        if (numberOfLines <= 1) {
            return 16.0
        } else if (numberOfLines == 2) {
            return 10.0
        } else {
            return 2.0
        }
    }

    internal func bannerWasTapped(sender: UITapGestureRecognizer) {
        delegate?.bannerWasTapped?(sender)

        if hideOptions != .NeverDismisses {
            hide()
        }
    }

    public func isVisible() -> Bool {
        return (window != nil)
    }

    public func show() {
        if rootView == nil {
            print("Root view needed to show banner")
            return
        }

        rootView!.addSubview(self)
        snp_remakeConstraints { (make) in
            make.height.equalTo(height)
            make.left.equalTo(rootView!).offset(sidePadding)
            make.right.equalTo(rootView!).offset(-sidePadding)

            switch placement {
            case .Bottom:
                make.top.equalTo(rootView!.snp_bottom)
                make.centerX.equalTo(rootView!)
            case .Top:
                make.bottom.equalTo(rootView!.snp_top)
                make.centerX.equalTo(rootView!)
            }
        }
        rootView!.layoutIfNeeded()

        snp_remakeConstraints { (make) in
            make.height.equalTo(height)

            if (placement == .Bottom) {
                make.bottom.equalTo(rootView!)
            } else {
                make.top.equalTo(rootView!)
            }

            make.left.equalTo(rootView!).offset(sidePadding)
            make.right.equalTo(rootView!).offset(-sidePadding)
        }

        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut,
            animations: {
                self.rootView!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.hideOptions == .DismissesAfterTime) {
                    self.showTimer = NSTimer.scheduledTimerWithTimeInterval(self.showDuration, target: self, selector: #selector(WBannerView.hide), userInfo: self, repeats: false)
                }
            }
        )

        setupUI()
    }

    public func hide() {
        showTimer?.invalidate()
        showTimer = nil

        if isVisible() {
            //animate out
            snp_remakeConstraints{ (make) in
                make.height.equalTo(height)
                make.left.equalTo(rootView!).offset(sidePadding)
                make.right.equalTo(rootView!).offset(-sidePadding)

                switch placement {
                case .Bottom:
                    make.top.equalTo(rootView!.snp_bottom)
                    make.centerX.equalTo(rootView!)
                case .Top:
                    make.bottom.equalTo(rootView!.snp_top)
                }
            }

            UIView.animateWithDuration(animationDuration,
                animations: {
                    self.rootView!.layoutIfNeeded()
                },
                completion: { finished in
                    self.removeFromSuperview()
                    self.delegate?.bannerDidHide?(self)
                }
            )
        }
    }
}

extension WBannerView: WLabelDelegate {
    public func lineCountChanged(lineCount: Int) {
        bodyNumberOfLines = lineCount
    }
}
