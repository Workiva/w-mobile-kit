//
//  WToast.swift
//  Pods

import Foundation
import UIKit
import SnapKit

@objc protocol WToastViewDelegate {
    optional func toastWasTapped(sender: UITapGestureRecognizer)
    optional func toastDidHide(toast: WToastView)
}

public enum WToastHideOptions {
    case DismissOnTap;
    case DismissesAfterTime;
}

let TOAST_HEIGHT = 64
let TOAST_OFFSET = 32
let TOAST_DEFAULT_SHOW_DURATION = 2.0
let TOAST_ANIMATION_DURATION = 0.3

public class WToastManager: NSObject, WToastViewDelegate {
    public var currentToast: WToastView?

    public static let sharedInstance = WToastManager()

    // Custom window can be provided
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

    @objc internal func toastWasTapped(sender: UITapGestureRecognizer) { }

    @objc internal func toastDidHide(toast: WToastView) {
        currentToast = nil
    }
}

public class WToastView: UIView {
    // Public API
    private weak var delegate: WToastViewDelegate?

    public var showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION {
        didSet {
            if showDuration > 0 {
                toastOptions = .DismissesAfterTime
            } else {
                toastOptions = .DismissOnTap
            }
        }
    }

    public var toastOptions: WToastHideOptions = .DismissesAfterTime

    public var message = "" {
        didSet {
            messageLabel.text = message
        }
    }

    public var rightIcon: UIImage? {
        didSet {
            iconImageView.image = rightIcon
        }
    }

    public var toastColor = UIColor.blackColor() {
        didSet {
            backgroundView.backgroundColor = toastColor
        }
    }

    public var messageLabel = UILabel()
    public var iconImageView = UIImageView()
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
    
    public convenience init(message: String, icon: UIImage? = nil, toastColor: UIColor = UIColor.blackColor(), alpha: CGFloat = 0.7, showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRectZero)
        
        self.message = message
        self.toastColor = toastColor
        self.backgroundView.alpha = alpha
        self.rightIcon = icon
        self.showDuration = showDuration
        iconImageView.alpha = alpha
    }
    
    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WToastView.hide), name: WConstants.NotificationKey.KillAllToasts, object: nil)
        
        addSubview(backgroundView)
        addSubview(messageLabel)
        addSubview(iconImageView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WToastViewDelegate.toastWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be 
        // overwritten by custom user values
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.textColor = UIColor.whiteColor()

        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
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
        
        iconImageView.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        iconImageView.image = rightIcon
        
        messageLabel.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
        }
        messageLabel.text = message

        layoutIfNeeded()
    }
    
    private func toastWasTapped(sender: UITapGestureRecognizer) {
        delegate?.toastWasTapped?(sender)
        hide()
    }

    public func isVisible() -> Bool {
        return (window != nil)
    }

    public func show() {
        WToastManager.sharedInstance.rootWindow!.addSubview(self)
        self.snp_makeConstraints { (make) in
            make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(0.8)
            make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
            make.height.equalTo(64)
        }
        WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()

        self.snp_remakeConstraints { (make) in
            make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(0.8)
            make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-TOAST_OFFSET)
            make.height.equalTo(TOAST_HEIGHT)
        }

        UIView.animateWithDuration(TOAST_ANIMATION_DURATION, delay: 0, options: .CurveEaseInOut,
            animations: {
                WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.toastOptions == .DismissesAfterTime) {
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
            //animate out
            snp_remakeConstraints{ (make) in
                make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(0.8)
                make.height.equalTo(TOAST_HEIGHT)
                make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            }

            UIView.animateWithDuration(TOAST_ANIMATION_DURATION,
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
