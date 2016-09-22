//
//  WSpinner.swift
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

public enum WSpinnerDirection: Equatable {
    case Clockwise, CounterClockwise
}

public class WSpinner: UIControl {
    // MARK: - Properties
    public var backgroundLayer: CAShapeLayer = CAShapeLayer()
    public var progressLayer: CAShapeLayer = CAShapeLayer()
    public var iconLayer: CALayer = CALayer()

    public var indeterminateSectionLength: CGFloat = 0.15 {
        didSet {
            if (indeterminate) {
                progress = indeterminateSectionLength
            }
        }
    }

    public var icon: UIImage? {
        didSet {
            iconLayer.contents = icon!.CGImage

            setNeedsDisplayMainThread()
        }
    }

    public var progressLineColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.75) {
        didSet {
            progressLayer.strokeColor = progressLineColor.CGColor

            setNeedsDisplayMainThread()
        }
    }

    public var backgroundLineColor: UIColor = UIColor(hex: 0xbfe4ff, alpha: 0.45) {
        didSet {
            backgroundLayer.strokeColor = backgroundLineColor.CGColor

            setNeedsDisplayMainThread()
        }
    }

    public var lineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = lineWidth;
            backgroundLayer.lineWidth = lineWidth;

            setNeedsDisplayMainThread()
        }
    }

    public var progress: CGFloat = 0 {
        didSet {
            if (progress >= 1.0) {
                progress = 1.0
            }

            setNeedsDisplayMainThread()
        }
    }

    public var indeterminate: Bool = false {
        didSet {
            if (oldValue == indeterminate) {
                return
            }

            if (indeterminate) {
                progress = self.indeterminateSectionLength

                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = direction == .Clockwise ? M_PI * 2 : -M_PI * 2
                rotationAnimation.duration = 1.4
                rotationAnimation.cumulative = true
                rotationAnimation.repeatCount = HUGE
                rotationAnimation.removedOnCompletion = false

                backgroundLayer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
                progressLayer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
            } else {
                backgroundLayer.removeAllAnimations()
                progressLayer.removeAllAnimations()
            }
        }
    }

    public var direction: WSpinnerDirection = .Clockwise {
        didSet {
            setNeedsDisplayMainThread()
        }
    }

    // MARK: - Inits
    public convenience init() {
        self.init(frame: CGRectZero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clearColor()
        progressLayer.strokeColor = progressLineColor.CGColor
        backgroundLayer.strokeColor = backgroundLineColor.CGColor

        setupBackgroundLayer()
        setupProgressLayer()
        setupIconLayer()
    }

    private func setupBackgroundLayer() {
        backgroundLayer.frame = bounds
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = kCALineCapRound

        if (backgroundLayer.superlayer != layer) {
            layer.insertSublayer(backgroundLayer, atIndex: 0)
        }
    }

    private func setupProgressLayer() {
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clearColor().CGColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = kCALineCapRound

        if (progressLayer.superlayer != layer) {
            layer.addSublayer(progressLayer)
        }
    }

    private func setupIconLayer() {
        iconLayer.frame = bounds

        if (iconLayer.superlayer != layer) {
            layer.addSublayer(iconLayer)
        }
    }

    // MARK: - Drawing
    public func setNeedsDisplayMainThread() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setNeedsDisplay()
        }
    }

    public override func drawRect(rect: CGRect) {
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        iconLayer.frame = bounds

        drawBackgroundCircle()
        drawProgress()
    }

    public func drawBackgroundCircle() {
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1

        backgroundLayer.path = circlePath(true)
    }

    public func drawProgress() {
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress

        progressLayer.path = circlePath(false)
    }

    private func circlePath(backgroundPath: Bool) -> CGPath {
        let isClockwise = direction == .Clockwise
        let startAngle = CGFloat(3 * M_PI / 2)
        let endAngle = isClockwise ? startAngle + CGFloat(2 * M_PI) : startAngle - CGFloat(2 * M_PI)
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        let radius = (bounds.size.width - lineWidth) / 2

        var path: UIBezierPath?

        if backgroundPath {
            path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
        } else {
            path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
        }

        path!.lineCapStyle = .Round

        return path!.CGPath
    }
}
