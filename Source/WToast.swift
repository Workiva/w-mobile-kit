//
//  WToast.swift
//  WMobileKit

import Foundation
import UIKit
import SnapKit

@objc public protocol WToastViewDelegate {
    optional func toastWasTapped(sender: UITapGestureRecognizer)
    optional func toastDidHide(toast: WToastView)
}

public enum WToastHideOptions {
    case DismissOnTap;
    case DismissesAfterTime;
}

public enum WToastPlacementOptions {
    case Top;
    case Bottom;
}

public enum WToastFlyInDirectionOptions {
    case FromTop;
    case FromRight;
    case FromBottom;
    case FromLeft;
}

let TOAST_DEFAULT_HEIGHT = 64
let TOAST_DEFAULT_PADDING = 32
let TOAST_DEFAULT_WIDTH_RATIO = 0.8
let TOAST_DEFAULT_SHOW_DURATION = 2.0
let TOAST_DEFAULT_ANIMATION_DURATION = 0.3

public class WToastManager: NSObject, WToastViewDelegate {
    public var currentToast: WToastView?

    public static let sharedInstance = WToastManager()

    // Custom window can be provided. Default to frontmost window.
    public var rootWindow: UIWindow? = UIApplication.sharedApplication().windows.first

    private override init() {
        super.init()
    }

    public func showToast(toast: WToastView) {
        NSNotificationCenter.defaultCenter().postNotificationName(WConstants.NotificationKey.KillAllToasts, object: nil)

        currentToast = toast
        currentToast?.delegate = self

        toast.show()
    }

    @objc public func toastWasTapped(sender: UITapGestureRecognizer) { }

    @objc public func toastDidHide(toast: WToastView) {
        currentToast = nil
    }
}

public class WToastView: UIView {
    // Public API
    public weak var delegate: WToastViewDelegate?

    // If 0 or less, options change to dismiss on tap
    public var showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION {
        didSet {
            if showDuration > 0 {
                toastHideOptions = .DismissesAfterTime
            } else {
                toastHideOptions = .DismissOnTap
            }
        }
    }

    public var toastHideOptions: WToastHideOptions = .DismissesAfterTime
    public var toastPlacement: WToastPlacementOptions = .Bottom {
        didSet {
            if (toastPlacement == .Top) {
                toastFlyInDirection = .FromTop
            } else {
                toastFlyInDirection = .FromBottom
            }
        }
    }
    public var toastFlyInDirection: WToastFlyInDirectionOptions = .FromBottom
    public var toastAnimationDuration = TOAST_DEFAULT_ANIMATION_DURATION
    public var toastHeight = TOAST_DEFAULT_HEIGHT
    public var toastWidth: Int?
    public var toastWidthRatio = TOAST_DEFAULT_WIDTH_RATIO
    public var toastTopPadding = TOAST_DEFAULT_PADDING
    public var toastBottomPadding = TOAST_DEFAULT_PADDING
    public var toastLeftPadding: Int?
    public var toastRightPadding: Int?

    public var message = "" {
        didSet {
            messageLabel.text = message
        }
    }

    public var rightIcon: UIImage? {
        didSet {
            rightIconImageView.image = rightIcon
        }
    }

    public var toastColor: UIColor = .blackColor() {
        didSet {
            backgroundView.backgroundColor = toastColor
        }
    }

    public var messageLabel = UILabel()
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
    
    public convenience init(message: String, icon: UIImage? = nil, toastColor: UIColor = .blackColor(), alpha: CGFloat = 0.7, showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRectZero)
        
        self.message = message
        self.toastColor = toastColor
        self.backgroundView.alpha = alpha
        self.rightIcon = icon
        self.showDuration = showDuration
        rightIconImageView.alpha = alpha
    }
    
    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WToastView.hide), name: WConstants.NotificationKey.KillAllToasts, object: nil)
        
        addSubview(backgroundView)
        addSubview(messageLabel)
        addSubview(rightIconImageView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WToastViewDelegate.toastWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be 
        // overwritten by custom user values
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.textColor = .whiteColor()

        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = .clearColor()
    }
    
    public func setupUI() {
        // Do not set any defaults here as they will overwrite any custom
        // values when the toast is shown.
        // Values set by variables should still be set.
        backgroundView.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        backgroundView.backgroundColor = toastColor
        
        rightIconImageView.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-frame.size.width / 10)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        rightIconImageView.image = rightIcon

        messageLabel.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(frame.size.width / 10)
            make.right.equalTo(self).offset(-frame.size.width / 10 - 14)
        }
        messageLabel.text = message

        layoutIfNeeded()
    }
    
    internal func toastWasTapped(sender: UITapGestureRecognizer) {
        delegate?.toastWasTapped?(sender)
        hide()
    }

    public func isVisible() -> Bool {
        return (window != nil)
    }

    public func show() {
        WToastManager.sharedInstance.rootWindow!.addSubview(self)
        snp_remakeConstraints { (make) in
            make.height.equalTo(toastHeight)
            
            if let toastWidth = toastWidth {
                make.width.equalTo(toastWidth)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(toastWidthRatio)
            }
            
            switch toastFlyInDirection {
                case .FromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                    break;
                case .FromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp_top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                    break;
                case .FromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp_left)
                    if (toastPlacement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastBottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastTopPadding)
                    }
                    break;
                case .FromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp_right)
                    if (toastPlacement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastBottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastTopPadding)
                    }
                    break;
            }
        }
        WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()

        snp_remakeConstraints { (make) in
            make.height.equalTo(toastHeight)
            
            if let toastWidth = toastWidth {
                make.width.equalTo(toastWidth)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(toastWidthRatio)
            }
            
            if (toastPlacement == .Bottom) {
                make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastBottomPadding)
            } else {
                make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastTopPadding)
            }
            
            if (toastFlyInDirection == .FromLeft && toastLeftPadding != nil) {
                make.left.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastLeftPadding!)
            } else if (toastFlyInDirection == .FromRight && toastRightPadding != nil) {
                make.right.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastRightPadding!)
            } else {
                make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            }
        }

        UIView.animateWithDuration(toastAnimationDuration, delay: 0, options: .CurveEaseInOut,
            animations: {
                WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.toastHideOptions == .DismissesAfterTime) {
                    self.showTimer = NSTimer.scheduledTimerWithTimeInterval(self.showDuration, target: self, selector: #selector(WToastView.hide), userInfo: self, repeats: false)
                }
            }
        )

        setupUI()
    }

    public func hide() {
        if let timer = showTimer {
            timer.invalidate()
            showTimer = nil
        }

        if (isVisible()) {
            NSNotificationCenter.defaultCenter().removeObserver(self)

            //animate out
            snp_remakeConstraints{ (make) in
                make.height.equalTo(toastHeight)
                
                if let toastWidth = toastWidth {
                    make.width.equalTo(toastWidth)
                } else {
                    make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(toastWidthRatio)
                }
                
                switch toastFlyInDirection {
                case .FromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                    break;
                case .FromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp_top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                    break;
                case .FromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp_left)
                    if (toastPlacement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastBottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastTopPadding)
                    }
                    break;
                case .FromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp_right)
                    if (toastPlacement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-toastBottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(toastTopPadding)
                    }
                    break;
                }
            }

            UIView.animateWithDuration(toastAnimationDuration,
                animations: {
                    WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
                },
                completion: { finished in
                    self.removeFromSuperview()
                    self.delegate?.toastDidHide?(self)
                }
            )
        }
    }
}
