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
    @objc optional func toastWasTapped(_ sender: UITapGestureRecognizer)
    @objc optional func toastDidHide(_ toast: WToastView)
}

public enum WToastHideOptions {
    case dismissOnTap, dismissesAfterTime
}

public enum WToastPlacementOptions {
    case top, bottom
}

public enum WToastFlyInDirectionOptions {
    case fromTop, fromRight, fromBottom, fromLeft
}

public let TOAST_DEFAULT_HEIGHT = 64
public let TOAST_DEFAULT_PADDING = 32
public let TOAST_DEFAULT_WIDTH_RATIO = 0.8
public let TOAST_DEFAULT_SHOW_DURATION = 2.0
public let TOAST_DEFAULT_ANIMATION_DURATION = 0.3

open class WToastManager: NSObject, WToastViewDelegate {
    open var currentToast: WToastView?

    open static let sharedInstance = WToastManager()

    // Custom window can be provided. Default to frontmost window.
    open var rootWindow: UIWindow? = UIApplication.shared.windows.first

    fileprivate override init() {
        super.init()
    }

    open func showToast(_ toast: WToastView) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: WConstants.NotificationKey.KillAllToasts), object: nil)

        currentToast = toast
        currentToast?.delegate = self

        toast.show()
    }

    @objc open func toastWasTapped(_ sender: UITapGestureRecognizer) { }

    @objc open func toastDidHide(_ toast: WToastView) {
        currentToast = nil
    }
}

open class WToastView: UIView {
    // Public API
    open weak var delegate: WToastViewDelegate?

    // If 0 or less, options change to dismiss on tap
    open var showDuration: TimeInterval = TOAST_DEFAULT_SHOW_DURATION {
        didSet {
            hideOptions = showDuration > 0 ? .dismissesAfterTime : .dismissOnTap
        }
    }

    open var hideOptions: WToastHideOptions = .dismissesAfterTime
    open var placement: WToastPlacementOptions = .bottom {
        didSet {
            flyInDirection = placement == .top ? .fromTop : .fromBottom
        }
    }
    open var flyInDirection: WToastFlyInDirectionOptions = .fromBottom
    open var animationDuration = TOAST_DEFAULT_ANIMATION_DURATION
    open var height = TOAST_DEFAULT_HEIGHT
    open var width: Int?
    open var widthRatio = TOAST_DEFAULT_WIDTH_RATIO
    open var topPadding = TOAST_DEFAULT_PADDING
    open var bottomPadding = TOAST_DEFAULT_PADDING
    open var leftPadding: Int?
    open var rightPadding: Int?
    open var heightConstraint: Constraint?

    open var message = "" {
        didSet {
            messageLabel.text = message
        }
    }

    open var rightIcon: UIImage? {
        didSet {
            rightIconImageView.image = rightIcon
        }
    }

    open var toastColor: UIColor = .black {
        didSet {
            backgroundView.backgroundColor = toastColor
        }
    }

    open var toastAlpha: CGFloat = 0.7 {
        didSet {
            backgroundView.alpha = toastAlpha
            rightIconImageView.alpha = toastAlpha
        }
    }

    open var messageLabel = UILabel()
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
    
    public convenience init(message: String, icon: UIImage? = nil, toastColor: UIColor = .black, toastAlpha: CGFloat = 0.7, showDuration: TimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRect.zero)
        
        self.message = message
        self.toastColor = toastColor
        self.backgroundView.alpha = toastAlpha
        self.rightIcon = icon
        self.showDuration = showDuration
        rightIconImageView.alpha = toastAlpha
    }
    
    fileprivate func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(WToastView.hide), name: NSNotification.Name(rawValue: WConstants.NotificationKey.KillAllToasts), object: nil)
        
        addSubview(backgroundView)
        addSubview(messageLabel)
        addSubview(rightIconImageView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WToastViewDelegate.toastWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be 
        // overwritten by custom user values
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .white

        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = .clear
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func setupUI() {
        // Do not set any defaults here as they will overwrite any custom
        // values when the toast is shown.
        // Values set by variables should still be set.
        backgroundView.snp.remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        backgroundView.backgroundColor = toastColor
        
        rightIconImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-frame.size.width / 10)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        rightIconImageView.image = rightIcon

        messageLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(self).offset(frame.size.width / 10)
            make.right.equalTo(self).offset(-frame.size.width / 10 - 14)
        }
        messageLabel.text = message

        backgroundView.alpha = toastAlpha
        rightIconImageView.alpha = toastAlpha

        layoutIfNeeded()
    }
    
    internal func toastWasTapped(_ sender: UITapGestureRecognizer) {
        delegate?.toastWasTapped?(sender)
        hide()
    }

    open func isVisible() -> Bool {
        return (window != nil)
    }

    open func show() {
        WToastManager.sharedInstance.rootWindow!.addSubview(self)
        snp.remakeConstraints { (make) in
            heightConstraint = make.height.equalTo(height).constraint

            if let width = width {
                make.width.equalTo(width)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
            }

            switch flyInDirection {
                case .fromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp.bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .fromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp.top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .fromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp.left)
                    if (placement == .bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                case .fromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp.right)
                    if (placement == .bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                }
        }

        WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
        setupUI()
        WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()

        snp.remakeConstraints { (make) in
            heightConstraint = make.height.equalTo(height).constraint

            if let width = width {
                make.width.equalTo(width)
            } else {
                make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
            }
            
            if (placement == .bottom) {
                make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
            } else {
                make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
            }
            
            if (flyInDirection == .fromLeft && leftPadding != nil) {
                make.left.equalTo(WToastManager.sharedInstance.rootWindow!).offset(leftPadding!)
            } else if (flyInDirection == .fromRight && rightPadding != nil) {
                make.right.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-rightPadding!)
            } else {
                make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
            }
        }

        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions(),
            animations: {
                WToastManager.sharedInstance.rootWindow!.layoutIfNeeded()
            },
            completion: { finished in
                if (self.hideOptions == .dismissesAfterTime) {
                    self.showTimer = Timer.scheduledTimer(timeInterval: self.showDuration, target: self, selector: #selector(WToastView.hide), userInfo: self, repeats: false)
                }
            }
        )
    }

    @objc open func hide() {
        showTimer?.invalidate()
        showTimer = nil

        if isVisible() {
            NotificationCenter.default.removeObserver(self)

            //animate out
            snp.remakeConstraints{ (make) in
                heightConstraint = make.height.equalTo(height).constraint

                if let width = width {
                    make.width.equalTo(width)
                } else {
                    make.width.equalTo(WToastManager.sharedInstance.rootWindow!).multipliedBy(widthRatio)
                }
                
                switch flyInDirection {
                case .fromBottom:
                    make.top.equalTo(WToastManager.sharedInstance.rootWindow!.snp.bottom)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .fromTop:
                    make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!.snp.top)
                    make.centerX.equalTo(WToastManager.sharedInstance.rootWindow!)
                case .fromLeft:
                    make.right.equalTo(WToastManager.sharedInstance.rootWindow!.snp.left)
                    if (placement == .bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                case .fromRight:
                    make.left.equalTo(WToastManager.sharedInstance.rootWindow!.snp.right)
                    if (placement == .bottom) {
                        make.bottom.equalTo(WToastManager.sharedInstance.rootWindow!).offset(-bottomPadding)
                    } else {
                        make.top.equalTo(WToastManager.sharedInstance.rootWindow!).offset(topPadding)
                    }
                }
            }

            UIView.animate(withDuration: animationDuration,
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

    public convenience init(firstLine: String, secondLine: String, icon: UIImage? = nil, toastColor: UIColor = .black,
                            toastAlpha: CGFloat = 0.7, showDuration: TimeInterval = TOAST_DEFAULT_SHOW_DURATION) {
        self.init(frame: CGRect.zero)

        self.firstLine = firstLine
        self.secondLine = secondLine
        self.toastColor = toastColor
        self.backgroundView.alpha = toastAlpha
        self.rightIcon = icon
        self.showDuration = showDuration
        rightIconImageView.alpha = toastAlpha
    }

    fileprivate override func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(WToastView.hide), name: NSNotification.Name(rawValue: WConstants.NotificationKey.KillAllToasts), object: nil)

        addSubview(backgroundView)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(rightIconImageView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(WToastViewDelegate.toastWasTapped(_:)))
        addGestureRecognizer(recognizer)

        // Set defaults here instead of the setupUI so they will not be
        // overwritten by custom user values
        firstLabel.numberOfLines = 1
        firstLabel.textAlignment = .center
        firstLabel.font = UIFont.systemFont(ofSize: 16)
        firstLabel.textColor = .white

        secondLabel.numberOfLines = 1
        secondLabel.textAlignment = .center
        secondLabel.font = UIFont.systemFont(ofSize: 16)
        secondLabel.textColor = .white

        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = .clear
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func setupUI() {
        // Do not set any defaults here as they will overwrite any custom
        // values when the toast is shown.
        // Values set by variables should still be set.
        backgroundView.snp.remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        backgroundView.backgroundColor = toastColor

        rightIconImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-frame.size.width / 10)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        rightIconImageView.image = rightIcon

        firstLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.height.equalTo(frame.size.height/2 - 8)
            make.left.equalTo(self).offset(frame.size.width / 10)
            make.right.equalTo(self).offset(-frame.size.width / 10 - 14)
        }
        firstLabel.text = firstLine

        secondLabel.snp.remakeConstraints { (make) in
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

public class WToastFlexibleView: WToastView {
    public var maxHeight: Int = 2 * TOAST_DEFAULT_HEIGHT

    public override func setupUI() {
        super.setupUI()

        let labelWidth = messageLabel.frame.width
        if let text = messageLabel.text {
            let toastLabelHeight = text.heightWithConstrainedWidth(labelWidth, font: messageLabel.font)
            height = min(Int(toastLabelHeight + 16), maxHeight)

            heightConstraint?.deactivate()
            snp.makeConstraints { make in
                heightConstraint = make.height.equalTo(height).constraint
            }

            layoutIfNeeded()
        }
    }

    override func commonInit() {
        super.commonInit()

        messageLabel.numberOfLines = 0
    }
}

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = (self as NSString).boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: font],
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
}
