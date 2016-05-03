//
//  WBanner.swift
//  WMobileKit

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

let BANNER_DEFAULT_HEIGHT = 80
let BANNER_DEFAULT_SHOW_DURATION = 0.0
let BANNER_DEFAULT_ANIMATION_DURATION = 0.3

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

    public var hideOptions: WBannerHideOptions = .NeverDismisses
    public var placement: WBannerPlacementOptions = .Bottom
    public var animationDuration = BANNER_DEFAULT_ANIMATION_DURATION
    public var height = BANNER_DEFAULT_HEIGHT

    public var titleMessage = "" {
        didSet {
            titleMessageLabel.text = bodyMessage
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

    public var bannerAlpha: CGFloat = 0.7 {
        didSet {
            backgroundView.alpha = bannerAlpha
            rightIconImageView.alpha = bannerAlpha
        }
    }

    public var titleMessageLabel = UILabel()
    public var bodyMessageLabel = UILabel()
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

    public convenience init(rootView: UIView, titleMessage: String, titleIcon: UIImage? = nil, bodyMessage: String, rightIcon: UIImage? = nil, bannerColor: UIColor = .blackColor(), bannerAlpha: CGFloat = 0.8) {
        self.init(frame: CGRectZero)

        self.rootView = rootView
        self.titleMessage = titleMessage
        self.titleIcon = titleIcon
        self.bodyMessage = bodyMessage
        self.bannerColor = bannerColor
        self.backgroundView.alpha = bannerAlpha
        self.rightIcon = rightIcon
        rightIconImageView.alpha = bannerAlpha
    }

    private func commonInit() {
        addSubview(backgroundView)
        addSubview(titleMessageLabel)
        addSubview(titleIconImageView)
        addSubview(bodyMessageLabel)
        addSubview(rightIconImageView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WBannerViewDelegate.bannerWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be
        // overwritten by custom user values
        titleMessageLabel.numberOfLines = 1
        titleMessageLabel.textAlignment = .Left
        titleMessageLabel.font = UIFont.systemFontOfSize(16)
        titleMessageLabel.textColor = .whiteColor()

        bodyMessageLabel.numberOfLines = 2
        bodyMessageLabel.textAlignment = .Left
        bodyMessageLabel.font = UIFont.systemFontOfSize(16)
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

        titleIconImageView.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(18)
            make.width.equalTo(18)
        }
        titleIconImageView.image = titleIcon

        rightIconImageView.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        rightIconImageView.image = rightIcon

        titleMessageLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.height.equalTo(18)
            make.left.equalTo(titleIconImageView.snp_right).offset(10)
            make.right.equalTo(rightIconImageView.snp_left).offset(-10)
        }
        titleMessageLabel.text = titleMessage

        bodyMessageLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(titleMessageLabel.snp_bottom).offset(2)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(rightIconImageView.snp_left).offset(-10)
        }
        bodyMessageLabel.text = bodyMessage

        backgroundView.alpha = bannerAlpha
        rightIconImageView.alpha = bannerAlpha

        layoutIfNeeded()
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
            make.left.equalTo(rootView!)
            make.right.equalTo(rootView!)

            switch placement {
            case .Bottom:
                make.top.equalTo(rootView!.snp_bottom)
                make.centerX.equalTo(rootView!)
                break;
            case .Top:
                make.bottom.equalTo(rootView!.snp_top)
                make.centerX.equalTo(rootView!)
                break;
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

            make.left.equalTo(rootView!)
            make.right.equalTo(rootView!)
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
                make.left.equalTo(rootView!)
                make.right.equalTo(rootView!)

                switch placement {
                case .Bottom:
                    make.top.equalTo(rootView!.snp_bottom)
                    make.centerX.equalTo(rootView!)
                    break;
                case .Top:
                    make.bottom.equalTo(rootView!.snp_top)
                    make.centerX.equalTo(rootView!)
                    break;
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
