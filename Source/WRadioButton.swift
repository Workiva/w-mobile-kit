//
//  WRadioButton.swift
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

let MIN_INDICATOR_RADIUS: CGFloat = 1.0
let MIN_RADIO_CIRCLE: CGFloat = 2.0
let wRadioButtonSelected = "wRadioButtonSelected"

public class WRadioCircleView: UIView { }
public class WRadioIndicatorView: UIView { }

public class WRadioButton: UIControl {
    public var radioCircle = WRadioCircleView()
    public var indicatorView = WRadioIndicatorView()

    public var groupID: Int = 0
    public var buttonID: Int = 0

    internal var pressRecognizer: UILongPressGestureRecognizer!

    public var buttonColor: UIColor = .whiteColor() {
        didSet {
            setupUI()
        }
    }

    public var highlightColor: UIColor = .grayColor() {
        didSet {
            setupUI()
        }
    }

    public var indicatorColor: UIColor = .darkGrayColor() {
        didSet {
            setupUI()
        }
    }

    public var borderColorNotSelected: UIColor = .lightGrayColor() {
        didSet {
            setupUI()
        }
    }

    public var borderColorSelected: UIColor = .lightGrayColor() {
        didSet {
            setupUI()
        }
    }

    public var borderWidth: CGFloat = 2 {
        didSet {
            setupUI()
        }
    }

    public var buttonRadius: CGFloat = 12.0 {
        didSet {
            // Lower bounds
            self.buttonRadius = max(MIN_RADIO_CIRCLE, buttonRadius)

            setupUI()
        }
    }

    public var indicatorRadius: CGFloat = 6.0 {
        didSet {
            // Upper bounds
            indicatorRadius = min(indicatorRadius, (buttonRadius-1))

            // Lower bounds
            indicatorRadius = max(MIN_INDICATOR_RADIUS, indicatorRadius)

            setupUI()
        }
    }

    public var animationTime: NSTimeInterval = 0.2

    // Threshold for touch up events registering
    public var touchThreshold: CGFloat = 25.0

    public override var selected: Bool {
        didSet {
            if selected {
                // Send selection notification with group id
                NSNotificationCenter.defaultCenter().postNotificationName(wRadioButtonSelected,
                                                                          object: self)
            }

            UIView.animateWithDuration(animationTime, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState],
                animations: {
                    self.indicatorView.alpha = oldValue ? 1.0 : 0.0
                },
                completion: { finished in
                    self.indicatorView.alpha = self.selected ? 1.0 : 0.0

                    self.layoutIfNeeded()
                }
            )

            if (oldValue != selected) {
                updateUISelectedChanged()
                sendActionsForControlEvents(.ValueChanged)
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
        self.init(frame: CGRectZero)

        self.selected = selected
    }

    public convenience init() {
        // Default to not selected
        self.init(false)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public func commonInit() {
        addSubview(radioCircle)
        addSubview(indicatorView)

        pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WRadioButton.buttonWasPressed(_:)))
        pressRecognizer.minimumPressDuration = 0.001
        addGestureRecognizer(pressRecognizer)

        radioCircle.clipsToBounds = true
        indicatorView.clipsToBounds = true

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(WRadioButton.radioButtonSelected(_:)),
            name: wRadioButtonSelected,
            object: nil)
    }

    public func setupUI() {
        bounds = CGRect(origin: bounds.origin, size: CGSize(width: buttonRadius * 2, height: buttonRadius * 2))

        radioCircle.snp_remakeConstraints { make in
            make.height.equalTo(buttonRadius * 2)
            make.width.equalTo(buttonRadius * 2)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }

        indicatorView.snp_remakeConstraints { make in
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

    public func updateUISelectedChanged() {
        radioCircle.layer.borderColor = selected ? borderColorSelected.CGColor : borderColorNotSelected.CGColor

        indicatorView.alpha = selected ? 1.0 : 0.0
    }

    public func radioButtonSelected(notification: NSNotification) {
        let sender: WRadioButton? = notification.object as! WRadioButton?

        if groupID == sender?.groupID {
            if !(buttonID == sender?.buttonID) {
                selected = false
            }
        }
    }

    /* Highlight will occur on touch start and as long as the press is
        within the touch threshold and will unhighlight if no longer in
        the threadhold, but will re-highlight if the press moves back in.
     Selection will only occur if the touch up is within the threshold.
     */
    public func buttonWasPressed(sender: UILongPressGestureRecognizer) {
        if (!enabled) {
            return
        }
        
        switch sender.state {
        case .Began:
            radioCircle.backgroundColor = highlightColor
        case .Changed:
            let distance: CGFloat = sender.locationInView(superview).distanceToPoint(center)

            if distance > touchThreshold {
                radioCircle.backgroundColor = buttonColor
            } else {
                radioCircle.backgroundColor = highlightColor
            }
        case .Ended:
            // Currently highlighted
            if radioCircle.backgroundColor == highlightColor {
                radioCircle.backgroundColor = buttonColor
                selected = true
            }
        default:
            break
        }
    }

    // Must have a invalidateIntrinsicContentSize() call in setupUI()
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: buttonRadius * 2, height: buttonRadius * 2)
    }
}
