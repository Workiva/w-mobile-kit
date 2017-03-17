//
//  WToast.swift
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

@objc public protocol WToastViewDelegate {
    optional func toastWasTapped(sender: UITapGestureRecognizer)
    optional func toastDidHide(toast: WToastView)
}

public enum WToastHideOptions {
    case DismissOnTap, DismissesAfterTime
}

public enum WToastPlacementOptions {
    case Top, Bottom
}

public enum WToastFlyInDirectionOptions {
    case FromTop, FromRight, FromBottom, FromLeft
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
            hideOptions = showDuration > 0 ? .DismissesAfterTime : .DismissOnTap
        }
    }

    public var hideOptions: WToastHideOptions = .DismissesAfterTime
    public var placement: WToastPlacementOptions = .Bottom {
        didSet {
            flyInDirection = placement == .Top ? .FromTop : .FromBottom
        }
    }
    public var flyInDirection: WToastFlyInDirectionOptions = .FromBottom
    public var animationDuration = TOAST_DEFAULT_ANIMATION_DURATION
    public var height = TOAST_DEFAULT_HEIGHT
    public var width: Int?
    public var widthRatio = TOAST_DEFAULT_WIDTH_RATIO
    public var topPadding = TOAST_DEFAULT_PADDING
    public var bottomPadding = TOAST_DEFAULT_PADDING
    public var leftPadding: Int?
    public var rightPadding: Int?

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

    public var toastAlpha: CGFloat = 0.7 {
        didSet {
            backgroundView.alpha = toastAlpha
            rightIconImageView.alpha = toastAlpha
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
    
    public convenience init(message: String, icon: UIImage? = nil, toastColor: UIColor = .blackColor(), toastAlpha: CGFloat = 0.7, showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRectZero)
        
        self.message = message
        self.toastColor = toastColor
        self.backgroundView.alpha = toastAlpha
        self.rightIcon = icon
        self.showDuration = showDuration
        rightIconImageView.alpha = toastAlpha
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

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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

        backgroundView.alpha = toastAlpha
        rightIconImageView.alpha = toastAlpha

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
            make.height.equalTo(height)
            
            if let width = width {
                make.width.equalTo(width)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
            }
            
            switch flyInDirection {
                case .FromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .FromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp_top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .FromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp_left)
                    if (placement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                case .FromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp_right)
                    if (placement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
            }
        }
        WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()

        snp_remakeConstraints { (make) in
            make.height.equalTo(height)
            
            if let width = width {
                make.width.equalTo(width)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
            }
            
            if (placement == .Bottom) {
                make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
            } else {
                make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
            }
            
            if (flyInDirection == .FromLeft && leftPadding != nil) {
                make.left.equalTo(WToastManager.sharedInstance.rootWindow!).offset(leftPadding!)
            } else if (flyInDirection == .FromRight && rightPadding != nil) {
                make.right.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-rightPadding!)
            } else {
                make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            }
        }

        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut,
            animations: {
                WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.hideOptions == .DismissesAfterTime) {
                    self.showTimer = NSTimer.scheduledTimerWithTimeInterval(self.showDuration, target: self, selector: #selector(WToastView.hide), userInfo: self, repeats: false)
                }
            }
        )

        setupUI()
    }

    public func hide() {
        showTimer?.invalidate()
        showTimer = nil

        if isVisible() {
            NSNotificationCenter.defaultCenter().removeObserver(self)

            //animate out
            snp_remakeConstraints{ (make) in
                make.height.equalTo(height)
                
                if let width = width {
                    make.width.equalTo(width)
                } else {
                    make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
                }
                
                switch flyInDirection {
                case .FromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp_bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .FromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp_top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .FromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp_left)
                    if (placement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                case .FromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp_right)
                    if (placement == .Bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                }
            }

            UIView.animateWithDuration(animationDuration,
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

public class WToastTwoLineView: WToastView {
    public var firstLine = "" {
        didSet {
            firstLabel.text = message
        }
    }

    public var secondLine = "" {
        didSet {
            secondLabel.text = message
        }
    }

    public var firstLabel = UILabel()
    public var secondLabel = UILabel()

    public convenience init(firstLine: String, secondLine: String, icon: UIImage? = nil, toastColor: UIColor = .blackColor(),
                            toastAlpha: CGFloat = 0.7, showDuration: NSTimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRectZero)

        self.firstLine = firstLine
        self.secondLine = secondLine
        self.toastColor = toastColor
        self.backgroundView.alpha = toastAlpha
        self.rightIcon = icon
        self.showDuration = showDuration
        rightIconImageView.alpha = toastAlpha
    }

    private override func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WToastView.hide), name: WConstants.NotificationKey.KillAllToasts, object: nil)

        addSubview(backgroundView)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(rightIconImageView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WToastViewDelegate.toastWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be
        // overwritten by custom user values
        firstLabel.numberOfLines = 1
        firstLabel.textAlignment = .Center
        firstLabel.font = UIFont.systemFontOfSize(16)
        firstLabel.textColor = .whiteColor()

        secondLabel.numberOfLines = 1
        secondLabel.textAlignment = .Center
        secondLabel.font = UIFont.systemFontOfSize(16)
        secondLabel.textColor = .whiteColor()

        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = .clearColor()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public override func setupUI() {
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

        firstLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.height.equalTo(frame.size.height/2 - 8)
            make.left.equalTo(self).offset(frame.size.width / 10)
            make.right.equalTo(self).offset(-frame.size.width / 10 - 14)
        }
        firstLabel.text = firstLine

        secondLabel.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self).offset(-8)
            make.height.equalTo(frame.size.height/2 - 8)
            make.left.equalTo(self).offset(frame.size.width / 10)
            make.right.equalTo(self).offset(-frame.size.width / 10 - 14)
        }
        secondLabel.text = secondLine

        backgroundView.alpha = toastAlpha
        rightIconImageView.alpha = toastAlpha
        
        layoutIfNeeded()
    }
}
