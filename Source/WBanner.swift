//
//  WBanner.swift
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
import SnapKit

@objc public protocol WBannerViewDelegate {
    @objc optional func bannerWasTapped(_ sender: UITapGestureRecognizer)
    @objc optional func bannerDidHide(_ bannerView: WBannerView)
}

public enum WBannerHideOptions {
    case neverDismisses, dismissOnTap, dismissesAfterTime
}

public enum WBannerPlacementOptions {
    case top, bottom
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

open class WBannerView: UIView {
    // Public API
    open weak var delegate: WBannerViewDelegate?

    open var rootView: UIView?

    // If 0 or less, options change to dismiss on tap
    open var showDuration: TimeInterval = BANNER_DEFAULT_SHOW_DURATION {
        didSet {
            hideOptions = showDuration > 0 ? .dismissesAfterTime : .dismissOnTap
        }
    }

    open var hideOptions: WBannerHideOptions = .dismissesAfterTime
    open var placement: WBannerPlacementOptions = .bottom
    open var animationDuration = BANNER_DEFAULT_ANIMATION_DURATION
    open var height = BANNER_DEFAULT_HEIGHT
    open var sidePadding: CGFloat = 0

    open var titleMessage = "" {
        didSet {
            titleMessageLabel.text = titleMessage
        }
    }
    open var bodyMessage = "" {
        didSet {
            bodyMessageLabel.text = bodyMessage
        }
    }

    open var titleIcon: UIImage? {
        didSet {
            titleIconImageView.image = titleIcon
        }
    }

    open var rightIcon: UIImage? {
        didSet {
            rightIconImageView.image = rightIcon
        }
    }

    open var bannerColor: UIColor = .black {
        didSet {
            backgroundView.backgroundColor = bannerColor
        }
    }

    open var bannerAlpha: CGFloat = 1.0 {
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

    open var titleMessageLabel = UILabel()
    open var bodyMessageLabel = WLabel()
    open var titleIconImageView = UIImageView()
    open var rightIconImageView = UIImageView()
    open var backgroundView = UIView()

    // Private API
    internal var showTimer: Timer?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init(rootView: UIView) {
        self.init(frame: CGRect.zero)

        self.rootView = rootView
    }

    public convenience init(rootView: UIView, titleMessage: String, titleIcon: UIImage? = nil, bodyMessage: String, rightIcon: UIImage? = nil, bannerColor: UIColor = .black, bannerAlpha: CGFloat = 1.0) {
        self.init(frame: CGRect.zero)

        self.rootView = rootView
        self.titleMessage = titleMessage
        self.titleIcon = titleIcon
        self.bodyMessage = bodyMessage
        self.bannerColor = bannerColor
        self.bannerAlpha = bannerAlpha
        self.rightIcon = rightIcon
    }

    fileprivate func commonInit() {
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
        titleMessageLabel.textAlignment = .left
        titleMessageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleMessageLabel.textColor = .white

        bodyMessageLabel.numberOfLines = bodyNumberOfLines
        bodyMessageLabel.textAlignment = .left
        bodyMessageLabel.font = UIFont.systemFont(ofSize: 12)
        bodyMessageLabel.textColor = .white
    }

    open func setupUI() {
        // Do not set any defaults here as they will overwrite any custom
        // values when the banner is shown.
        // Values set by variables should still be set.
        backgroundView.snp.remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        backgroundView.backgroundColor = bannerColor

        titleIconImageView.image = titleIcon
        if (titleIconImageView.image != nil) {
            titleIconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(self).offset(BANNER_DEFAULT_LEFT_PADDING)
                make.top.equalTo(self).offset(verticalPaddingForNumberOfLines(bodyNumberOfLines))
                make.height.equalTo(15)
                make.width.equalTo(15)
            }
        } else {
            // Hide if not populated
            titleIconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
        }

        rightIconImageView.image = rightIcon
        if (rightIconImageView.image != nil) {
            rightIconImageView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
                make.height.equalTo(16)
                make.width.equalTo(16)
            }
        } else {
            // Hide if not populated
            rightIconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
        }

        titleMessageLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(verticalPaddingForNumberOfLines(bodyNumberOfLines))
            make.height.equalTo(15)

            if (titleIconImageView.image != nil) {
                make.left.equalTo(titleIconImageView.snp.right).offset(6)
            } else {
                make.left.equalTo(self).offset(BANNER_DEFAULT_RIGHT_PADDING)
            }

            if (rightIconImageView.image != nil) {
                make.right.equalTo(rightIconImageView.snp.left).offset(-BANNER_RIGHT_ICON_IMAGE_VIEW_PADDING)
            } else {
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
            }
        }
        titleMessageLabel.text = titleMessage

        bodyMessageLabel.snp.remakeConstraints { (make) in
            if (bodyNumberOfLines <= 1) {
                make.top.equalTo(titleMessageLabel.snp.bottom).offset(7)
            } else {
                make.top.equalTo(titleMessageLabel.snp.bottom).offset(4)
            }

            make.bottom.equalTo(self).offset(-verticalPaddingForNumberOfLines(bodyNumberOfLines))
            make.left.equalTo(self).offset(BANNER_DEFAULT_LEFT_PADDING)

            if (rightIconImageView.image != nil) {
                make.right.equalTo(rightIconImageView.snp.left).offset(-BANNER_RIGHT_ICON_IMAGE_VIEW_PADDING)
            } else {
                make.right.equalTo(self).offset(-BANNER_DEFAULT_RIGHT_PADDING)
            }
        }
        bodyMessageLabel.text = bodyMessage

        backgroundView.alpha = bannerAlpha
        rightIconImageView.alpha = bannerAlpha

        layoutIfNeeded()
    }

    fileprivate func verticalPaddingForNumberOfLines(_ numberOfLines: Int) -> CGFloat {
        if (numberOfLines <= 1) {
            return 16.0
        } else if (numberOfLines == 2) {
            return 10.0
        } else {
            return 2.0
        }
    }

    internal func bannerWasTapped(_ sender: UITapGestureRecognizer) {
        delegate?.bannerWasTapped?(sender)

        if hideOptions != .neverDismisses {
            hide()
        }
    }

    open func isVisible() -> Bool {
        return (window != nil)
    }

    open func show() {
        if rootView == nil {
            print("Root view needed to show banner")
            return
        }

        rootView!.addSubview(self)
        snp.remakeConstraints { (make) in
            make.height.equalTo(height)
            make.left.equalTo(rootView!).offset(sidePadding)
            make.right.equalTo(rootView!).offset(-sidePadding)

            switch placement {
            case .bottom:
                make.top.equalTo(rootView!.snp.bottom)
                make.centerX.equalTo(rootView!)
            case .top:
                make.bottom.equalTo(rootView!.snp.top)
                make.centerX.equalTo(rootView!)
            }
        }
        rootView!.layoutIfNeeded()

        snp.remakeConstraints { (make) in
            make.height.equalTo(height)

            if (placement == .bottom) {
                make.bottom.equalTo(rootView!)
            } else {
                make.top.equalTo(rootView!)
            }

            make.left.equalTo(rootView!).offset(sidePadding)
            make.right.equalTo(rootView!).offset(-sidePadding)
        }

        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions(),
            animations: {
                self.rootView!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.hideOptions == .dismissesAfterTime) {
                    self.showTimer = Timer.scheduledTimer(timeInterval: self.showDuration, target: self, selector: #selector(WBannerView.hide), userInfo: self, repeats: false)
                }
            }
        )

        setupUI()
    }

    open func hide() {
        showTimer?.invalidate()
        showTimer = nil

        if isVisible() {
            //animate out
            snp.remakeConstraints{ (make) in
                make.height.equalTo(height)
                make.left.equalTo(rootView!).offset(sidePadding)
                make.right.equalTo(rootView!).offset(-sidePadding)

                switch placement {
                case .bottom:
                    make.top.equalTo(rootView!.snp.bottom)
                    make.centerX.equalTo(rootView!)
                case .top:
                    make.bottom.equalTo(rootView!.snp.top)
                }
            }

            UIView.animate(withDuration: animationDuration,
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
    public func lineCountChanged(_ lineCount: Int) {
        bodyNumberOfLines = lineCount
    }
}
