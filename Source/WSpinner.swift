//
//  WSpinner.swift
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

public enum WSpinnerDirection: Equatable {
    case clockwise, counterClockwise
}

open class WSpinner: UIControl {
    // MARK: - Properties
    open var backgroundLayer: CAShapeLayer = CAShapeLayer()
    open var progressLayer: CAShapeLayer = CAShapeLayer()
    open var iconLayer: CALayer = CALayer()

    open var indeterminateSectionLength: CGFloat = 0.15 {
        didSet {
            if (indeterminate) {
                progress = indeterminateSectionLength
            }
        }
    }

    open var icon: UIImage? {
        didSet {
            iconLayer.contents = icon!.cgImage

            setNeedsDisplayMainThread()
        }
    }

    open var progressLineColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.75) {
        didSet {
            progressLayer.strokeColor = progressLineColor.cgColor

            setNeedsDisplayMainThread()
        }
    }

    open var backgroundLineColor: UIColor = UIColor(hex: 0xbfe4ff, alpha: 0.45) {
        didSet {
            backgroundLayer.strokeColor = backgroundLineColor.cgColor

            setNeedsDisplayMainThread()
        }
    }

    open var lineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = lineWidth;
            backgroundLayer.lineWidth = lineWidth;

            setNeedsDisplayMainThread()
        }
    }

    open var progress: CGFloat = 0 {
        didSet {
            if (progress >= 1.0) {
                progress = 1.0
            }

            setNeedsDisplayMainThread()
        }
    }

    open var indeterminate: Bool = false {
        didSet {
            if (oldValue == indeterminate) {
                return
            }

            if (indeterminate) {
                progress = self.indeterminateSectionLength

                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = direction == .clockwise ? Double.pi * 2 : -Double.pi * 2
                rotationAnimation.duration = 1.4
                rotationAnimation.isCumulative = true
                rotationAnimation.repeatCount = HUGE
                rotationAnimation.isRemovedOnCompletion = false

                backgroundLayer.add(rotationAnimation, forKey: "rotationAnimation")
                progressLayer.add(rotationAnimation, forKey: "rotationAnimation")
            } else {
                backgroundLayer.removeAllAnimations()
                progressLayer.removeAllAnimations()
            }
        }
    }

    open var direction: WSpinnerDirection = .clockwise {
        didSet {
            setNeedsDisplayMainThread()
        }
    }

    // MARK: - Inits
    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    fileprivate func commonInit() {
        backgroundColor = .clear
        progressLayer.strokeColor = progressLineColor.cgColor
        backgroundLayer.strokeColor = backgroundLineColor.cgColor

        setupBackgroundLayer()
        setupProgressLayer()
        setupIconLayer()
    }

    fileprivate func setupBackgroundLayer() {
        backgroundLayer.frame = bounds
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = CAShapeLayerLineCap.round

        if (backgroundLayer.superlayer != layer) {
            layer.insertSublayer(backgroundLayer, at: 0)
        }
    }

    fileprivate func setupProgressLayer() {
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = CAShapeLayerLineCap.round

        if (progressLayer.superlayer != layer) {
            layer.addSublayer(progressLayer)
        }
    }

    fileprivate func setupIconLayer() {
        iconLayer.frame = bounds

        if (iconLayer.superlayer != layer) {
            layer.addSublayer(iconLayer)
        }
    }

    // MARK: - Drawing
    open func setNeedsDisplayMainThread() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }

    open override func draw(_ rect: CGRect) {
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        iconLayer.frame = bounds

        drawBackgroundCircle()
        drawProgress()
    }

    open func drawBackgroundCircle() {
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1

        backgroundLayer.path = circlePath(true)
    }

    open func drawProgress() {
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress

        progressLayer.path = circlePath(false)
    }

    fileprivate func circlePath(_ backgroundPath: Bool) -> CGPath {
        let isClockwise = direction == .clockwise
        let startAngle = CGFloat(3 * Double.pi / 2)
        let endAngle = isClockwise ? startAngle + CGFloat(2 * Double.pi) : startAngle - CGFloat(2 * Double.pi)
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = (bounds.size.width - lineWidth) / 2

        var path: UIBezierPath?

        if backgroundPath {
            path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
        } else {
            path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
        }

        path!.lineCapStyle = .round

        return path!.cgPath
    }
}
