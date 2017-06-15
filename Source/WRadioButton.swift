//
//  WRadioButton.swift
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

let MIN_INDICATOR_RADIUS: CGFloat = 1.0
let MIN_RADIO_CIRCLE: CGFloat = 2.0
let wRadioButtonSelected = "wRadioButtonSelected"

open class WRadioCircleView: UIView { }
open class WRadioIndicatorView: UIView { }

open class WRadioButton: UIControl {
    open var radioCircle = WRadioCircleView()
    open var indicatorView = WRadioIndicatorView()

    open var groupID: Int = 0
    open var buttonID: Int = 0

    internal var pressRecognizer: UILongPressGestureRecognizer!

    open var buttonColor: UIColor = .white {
        didSet {
            setupUI()
        }
    }

    open var highlightColor: UIColor = .gray {
        didSet {
            setupUI()
        }
    }

    open var indicatorColor: UIColor = .darkGray {
        didSet {
            setupUI()
        }
    }


    open var borderColorNotSelected: UIColor = .lightGray {
        didSet {
            setupUI()
        }
    }

    open var borderColorSelected: UIColor = .lightGray {
        didSet {
            setupUI()
        }
    }

    open var borderWidth: CGFloat = 2 {
        didSet {
            setupUI()
        }
    }

    open var buttonRadius: CGFloat = 12.0 {
        didSet {
            // Lower bounds
            self.buttonRadius = max(MIN_RADIO_CIRCLE, buttonRadius)

            setupUI()
        }
    }

    open var indicatorRadius: CGFloat = 6.0 {
        didSet {
            // Upper bounds
            indicatorRadius = min(indicatorRadius, (buttonRadius-1))

            // Lower bounds
            indicatorRadius = max(MIN_INDICATOR_RADIUS, indicatorRadius)

            setupUI()
        }
    }

    open var animationTime: TimeInterval = 0.2

    // Threshold for touch up events registering
    open var touchThreshold: CGFloat = 25.0

    open override var isSelected: Bool {
        didSet {
            if isSelected {
                // Send selection notification with group id
                NotificationCenter.default.post(name: Notification.Name(rawValue: wRadioButtonSelected),
                                                                          object: self)
            }

            UIView.animate(withDuration: animationTime, delay: 0, options: .beginFromCurrentState,
                animations: {
                    self.indicatorView.alpha = oldValue ? 1.0 : 0.0
                },
                completion: { finished in
                    self.indicatorView.alpha = self.isSelected ? 1.0 : 0.0

                    self.layoutIfNeeded()
                }
            )

            if (oldValue != isSelected) {
                updateUISelectedChanged()
                sendActions(for: .valueChanged)
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUI()
    }

    public override init(frame: CGRect) {
        let newFrame = CGRect(origin: frame.origin, size: CGSize(width: buttonRadius * 2, height: buttonRadius * 2))
        super.init(frame: newFrame)

        commonInit()
        setupUI()
    }

    public convenience init(_ selected: Bool) {
        self.init(frame: CGRect.zero)

        self.isSelected = selected
    }

    public convenience init() {
        // Default to not selected
        self.init(false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open func commonInit() {
        addSubview(radioCircle)
        addSubview(indicatorView)

        pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WRadioButton.buttonWasPressed(_:)))
        pressRecognizer.minimumPressDuration = 0.001
        addGestureRecognizer(pressRecognizer)

        radioCircle.clipsToBounds = true
        indicatorView.clipsToBounds = true

        NotificationCenter.default.addObserver(self,
            selector: #selector(WRadioButton.radioButtonSelected(notification:)),
            name: NSNotification.Name(rawValue: wRadioButtonSelected),
            object: nil)
    }

    open func setupUI() {
        bounds = CGRect(origin: bounds.origin, size: CGSize(width: buttonRadius * 2, height: buttonRadius * 2))

        radioCircle.snp.remakeConstraints { make in
            make.height.equalTo(buttonRadius * 2)
            make.width.equalTo(buttonRadius * 2)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }

        indicatorView.snp.remakeConstraints { make in
            make.centerX.equalTo(radioCircle)
            make.centerY.equalTo(radioCircle)
            make.height.equalTo(indicatorRadius * 2)
            make.width.equalTo(indicatorRadius * 2)
        }

        radioCircle.backgroundColor = buttonColor
        radioCircle.layer.borderWidth = borderWidth

        indicatorView.backgroundColor = indicatorColor

        updateUISelectedChanged()

        // Need to set the frame first or will result in square
        layoutIfNeeded()

        radioCircle.layer.cornerRadius = radioCircle.frame.size.height / 2
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width / 2

        invalidateIntrinsicContentSize()
    }


    open func updateUISelectedChanged() {
        radioCircle.layer.borderColor = isSelected ? borderColorSelected.cgColor : borderColorNotSelected.cgColor

        indicatorView.alpha = isSelected ? 1.0 : 0.0
    }

    @objc open func radioButtonSelected(notification: NSNotification) {
        let sender: WRadioButton? = notification.object as! WRadioButton?

        if groupID == sender?.groupID {
            if !(buttonID == sender?.buttonID) {
                isSelected = false
            }
        }
    }

    /* Highlight will occur on touch start and as long as the press is
        within the touch threshold and will unhighlight if no longer in
        the threadhold, but will re-highlight if the press moves back in.
     Selection will only occur if the touch up is within the threshold.
     */
    @objc open func buttonWasPressed(_ sender: UILongPressGestureRecognizer) {
        if (!isEnabled) {
            return
        }
        
        switch sender.state {
        case .began:
            radioCircle.backgroundColor = highlightColor
        case .changed:
            let distance: CGFloat = sender.location(in: superview).distanceToPoint(center)

            if distance > touchThreshold {
                radioCircle.backgroundColor = buttonColor
            } else {
                radioCircle.backgroundColor = highlightColor
            }
        case .ended:
            // Currently highlighted
            if radioCircle.backgroundColor == highlightColor {
                radioCircle.backgroundColor = buttonColor
                isSelected = true
            }
        default:
            break
        }
    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    open override var intrinsicContentSize : CGSize {
        return CGSize(width: buttonRadius * 2, height: buttonRadius * 2)
    }
}
