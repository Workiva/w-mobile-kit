//
//  WFAButton.swift
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
import SnapKit

public class WFAButton: UIControl {
    public var icon: UIImage? {
        didSet {
            if let icon = icon {
                imageView.image = icon
            } else {
                imageView.image = nil
            }
        }
    }
    public var buttonColor: UIColor = .blueColor()
    public var pressedButtonColor: UIColor?

    // Can manually set cornerRadius, otherwise it will be circular
    public var cornerRadius: CGFloat? {
        didSet {
            setupUI()
        }
    }
    public var hasShadow = true

    // How far the user can drag away from the button until it won't register press
    public var dragBuffer: CGFloat = 10

    var buttonBackgroundView = UIView()
    var imageView = UIImageView()
    var darkOverlay = UIView()

    // If the icon already has the colored background view, set this to true and the background view will be hidden and the image view will fill the view instead of having insets
    public var iconContainsBackgroundView = false {
        didSet {
            setupUI()
        }
    }

    public override var bounds: CGRect {
        didSet {
            setupUI()
        }
    }

    convenience init() {
        self.init(frame: CGRectZero)

        commonInit()
        setupUI()
    }

    public func commonInit() {
        addSubview(buttonBackgroundView)
        addSubview(imageView)
        addSubview(darkOverlay)

        buttonBackgroundView.backgroundColor = buttonColor
        darkOverlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        darkOverlay.hidden = true
        darkOverlay.userInteractionEnabled = false

        imageView.userInteractionEnabled = false

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WFAButton.buttonWasLongPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.001

        addGestureRecognizer(longPressRecognizer)
    }

    public func setupUI() {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            return
        }

        let smallestEdge = min(frame.size.height, frame.size.width)
        buttonBackgroundView.snp_remakeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(smallestEdge)
        }

        imageView.snp_remakeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(buttonBackgroundView).offset(iconContainsBackgroundView ? 0 : -10)
        }

        darkOverlay.snp_remakeConstraints { (make) in
            make.edges.equalTo(buttonBackgroundView)
        }

        buttonBackgroundView.hidden = iconContainsBackgroundView
        buttonBackgroundView.layer.cornerRadius = cornerRadius ?? smallestEdge / 2
        buttonBackgroundView.clipsToBounds = true
        darkOverlay.layer.cornerRadius = cornerRadius ?? smallestEdge / 2
        darkOverlay.clipsToBounds = true

        layoutIfNeeded()

        if (hasShadow) {
            var nonShadowLayer = buttonBackgroundView.hidden ? buttonBackgroundView.layer : imageView.layer
            var shadowLayer = buttonBackgroundView.hidden ? imageView.layer : buttonBackgroundView.layer

            shadowLayer.masksToBounds = false
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowColor = UIColor.blackColor().CGColor
            shadowLayer.shadowRadius = 3
            shadowLayer.shadowOffset = CGSize(width: 3, height: 3)

            nonShadowLayer.shadowOpacity = 0.0
        }
    }

    public func buttonWasLongPressed(recognizer: UILongPressGestureRecognizer) {
        let touchLocation = recognizer.locationInView(self)

        switch recognizer.state {
        case .Began:
            if let pressedButtonColor = pressedButtonColor {
                buttonBackgroundView.backgroundColor = pressedButtonColor
                darkOverlay.hidden = true
            } else {
                buttonBackgroundView.backgroundColor = buttonColor
                darkOverlay.hidden = false
            }
        case .Changed:
            if (!pointIsWithinView(touchLocation, withBuffer: dragBuffer)) {
                buttonBackgroundView.backgroundColor = buttonColor
                darkOverlay.hidden = true

                sendActionsForControlEvents(.TouchDragOutside)
            } else {
                if let pressedButtonColor = pressedButtonColor {
                    buttonBackgroundView.backgroundColor = pressedButtonColor
                    darkOverlay.hidden = true
                } else {
                    buttonBackgroundView.backgroundColor = buttonColor
                    darkOverlay.hidden = false
                }

                sendActionsForControlEvents(.TouchDragInside)
            }
        case .Ended, .Cancelled, .Failed:
            buttonBackgroundView.backgroundColor = buttonColor
            darkOverlay.hidden = true
            if (!pointIsWithinView(touchLocation, withBuffer: dragBuffer)) {
                sendActionsForControlEvents(.TouchUpOutside)
            } else {
                sendActionsForControlEvents(.TouchUpInside)
            }
        default:
            break
        }
    }

    func pointIsWithinView(point: CGPoint, withBuffer buffer: CGFloat) -> Bool {
        return !(point.x < -buffer || point.x > self.frame.size.width + buffer || point.y < -buffer || point.y > self.frame.size.height + buffer)
    }
}
