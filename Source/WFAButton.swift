//
//  WFAButton.swift
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
    public var buttonColor: UIColor = .blue
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
        self.init(frame: CGRect.zero)

        commonInit()
        setupUI()
    }

    public func commonInit() {
        addSubview(buttonBackgroundView)
        addSubview(imageView)
        addSubview(darkOverlay)

        buttonBackgroundView.backgroundColor = buttonColor
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        darkOverlay.isHidden = true
        darkOverlay.isUserInteractionEnabled = false

        imageView.isUserInteractionEnabled = false

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WFAButton.buttonWasLongPressed(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.001

        addGestureRecognizer(longPressRecognizer)
    }

    public func setupUI() {
        if (frame.equalTo(CGRect.zero)) {
            return
        }

        let smallestEdge = min(frame.size.height, frame.size.width)
        buttonBackgroundView.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(smallestEdge)
        }

        imageView.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(buttonBackgroundView).offset(iconContainsBackgroundView ? 0 : -10)
        }

        darkOverlay.snp.remakeConstraints { (make) in
            make.edges.equalTo(buttonBackgroundView)
        }

        buttonBackgroundView.isHidden = iconContainsBackgroundView
        buttonBackgroundView.layer.cornerRadius = cornerRadius ?? smallestEdge / 2
        buttonBackgroundView.clipsToBounds = true
        darkOverlay.layer.cornerRadius = cornerRadius ?? smallestEdge / 2
        darkOverlay.clipsToBounds = true

        layoutIfNeeded()

        if (hasShadow) {
            let nonShadowLayer = buttonBackgroundView.isHidden ? buttonBackgroundView.layer : imageView.layer
            let shadowLayer = buttonBackgroundView.isHidden ? imageView.layer : buttonBackgroundView.layer

            shadowLayer.masksToBounds = false
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowRadius = 3
            shadowLayer.shadowOffset = CGSize(width: 3, height: 3)

            nonShadowLayer.shadowOpacity = 0.0
        }
    }

    @objc public func buttonWasLongPressed(recognizer: UILongPressGestureRecognizer) {
        let touchLocation = recognizer.location(in: self)

        switch recognizer.state {
        case .began:
            if let pressedButtonColor = pressedButtonColor {
                buttonBackgroundView.backgroundColor = pressedButtonColor
                darkOverlay.isHidden = true
            } else {
                buttonBackgroundView.backgroundColor = buttonColor
                darkOverlay.isHidden = false
            }
        case .changed:
            if (!pointIsWithinView(point: touchLocation, withBuffer: dragBuffer)) {
                buttonBackgroundView.backgroundColor = buttonColor
                darkOverlay.isHidden = true

                sendActions(for: .touchDragOutside)
            } else {
                if let pressedButtonColor = pressedButtonColor {
                    buttonBackgroundView.backgroundColor = pressedButtonColor
                    darkOverlay.isHidden = true
                } else {
                    buttonBackgroundView.backgroundColor = buttonColor
                    darkOverlay.isHidden = false
                }

                sendActions(for: .touchDragInside)
            }
        case .ended, .cancelled, .failed:
            buttonBackgroundView.backgroundColor = buttonColor
            darkOverlay.isHidden = true
            if (!pointIsWithinView(point: touchLocation, withBuffer: dragBuffer)) {
                sendActions(for: .touchUpOutside)
            } else {
                sendActions(for: .touchUpInside)
            }
        default:
            break
        }
    }

    func pointIsWithinView(point: CGPoint, withBuffer buffer: CGFloat) -> Bool {
        return !(point.x < -buffer || point.x > self.frame.size.width + buffer || point.y < -buffer || point.y > self.frame.size.height + buffer)
    }
}
