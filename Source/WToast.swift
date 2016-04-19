//
//  WToast.swift
//  Pods

import Foundation
import UIKit
import SnapKit

@objc protocol WToastViewDelegate {
    optional func toastWasTapped(sender: UITapGestureRecognizer)
}

public enum WToastHideOptions {
    case DismissOnTap;
    case DismissesAfterTime;
}

let TOAST_HEIGHT = 64
let TOAST_OFFSET = 32
let TOAST_SHOW_DURATION = 2.0
let TOAST_ANIMATION_DURATION = 0.3

public class WToastManager: NSObject, WToastViewDelegate {
    var currentToast: WToastView?
    var showTimer: NSTimer?

    public static let sharedInstance = WToastManager()
    
    public var rootWindow: UIWindow? {
        get {
            return UIApplication.sharedApplication().windows.first
        }
    }
    
    private override init() {
        super.init()
    }
    
    public func showToast(toast: WToastView) {
        showTimer?.invalidate()
        
        currentToast = toast
        currentToast?.delegate = self
        
        NSNotificationCenter.defaultCenter().postNotificationName("killAllToasts", object: nil)
        
        rootWindow?.addSubview(toast)
        toast.snp_makeConstraints { (make) in
            make.centerX.equalTo(rootWindow!)
            make.width.equalTo(rootWindow!).multipliedBy(0.8)
            make.top.equalTo(rootWindow!.snp_bottom)
            make.height.equalTo(64)
        }
        rootWindow!.layoutIfNeeded()
        
        toast.snp_remakeConstraints { (make) in
            make.centerX.equalTo(rootWindow!)
            make.width.equalTo(rootWindow!).multipliedBy(0.8)
            make.bottom.equalTo(rootWindow!).offset(-TOAST_OFFSET)
            make.height.equalTo(TOAST_HEIGHT)
        }

        UIView.animateWithDuration(TOAST_ANIMATION_DURATION, delay: 0, options: .CurveEaseInOut,
            animations: {
                self.rootWindow?.layoutIfNeeded()
            },
            completion: { finished in
                if (toast.toastOptions == .DismissesAfterTime) {
                    self.showTimer = NSTimer.scheduledTimerWithTimeInterval(TOAST_SHOW_DURATION, target: self, selector: "hideToast", userInfo: toast, repeats: false)
                }
            }
        )
        
        currentToast?.setupUI()
    }
    
    public func hideToast() {
        if let showTimer = showTimer {
            showTimer.invalidate()
        }
        
        if let currentToast = currentToast {
            currentToast.snp_remakeConstraints { (make) in
                make.centerX.equalTo(rootWindow!)
                make.width.equalTo(rootWindow!).multipliedBy(0.8)
                make.top.equalTo(rootWindow!.snp_bottom)
                make.height.equalTo(TOAST_HEIGHT)
            }
            
            UIView.animateWithDuration(TOAST_ANIMATION_DURATION,
                animations: {
                    self.rootWindow!.layoutIfNeeded()
                },
                completion: { finished in
                    currentToast.removeFromSuperview()
                    self.currentToast = nil
                }
            )
        }
    }
    
    func toastWasTapped(sender: UITapGestureRecognizer) {
        hideToast()
    }
}

public class WToastView: UIView {
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
    
    private weak var delegate: WToastViewDelegate?
    public var toastOptions: WToastHideOptions = .DismissesAfterTime
    public var messageLabel = UILabel(frame: CGRectZero)
    public var iconImageView = UIImageView(frame: CGRectZero)
    public var backgroundView = UIView(frame: CGRectZero)

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public convenience init(message: String, icon: UIImage? = nil, toastColor: UIColor = UIColor.blackColor(), alpha: CGFloat = 0.7) {
        self.init(frame: CGRectZero)
        
        self.message = message
        self.toastColor = toastColor
        self.backgroundView.alpha = alpha
        self.rightIcon = icon
        iconImageView.alpha = alpha
    }
    
    public func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("hide"), name: "killAllToasts", object: nil)
        
        addSubview(backgroundView)
        addSubview(messageLabel)
        addSubview(iconImageView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("toastWasTapped:"))
        addGestureRecognizer(recognizer)
    }
    
    public func setupUI() {
        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
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
        messageLabel.numberOfLines = 1
        messageLabel.text = message
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.textColor = UIColor.whiteColor()

        layoutIfNeeded()
    }
    
    func toastWasTapped(sender: UITapGestureRecognizer) {
        delegate?.toastWasTapped?(sender)
    }
    
    func hide() {
        removeFromSuperview()
    }
}
