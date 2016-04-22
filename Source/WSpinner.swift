//
//  WSpinner.swift
//  WMobileKit

import Foundation
import UIKit

let startAngle = -CGFloat(M_PI / 2)

public class WSpinner: UIControl {
    // MARK: - Properties
    var backgroundLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var iconLayer = CALayer()
    public var indeterminateGapLength: Double? {
        didSet {
            // It's
            indeterminateGapLength! *= 2
        }
    }

    public var icon = UIImage?() {
        didSet {
            setNeedsDisplayMainThread()
        }
    }

    public var progressLineColor: UIColor? {
        didSet {
            progressLayer.strokeColor = progressLineColor!.CGColor

            setNeedsDisplayMainThread()
        }
    }

    public var backgroundLineColor: UIColor? {
        didSet {
            backgroundLayer.strokeColor = backgroundLineColor!.CGColor

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
            setNeedsDisplayMainThread()
        }
    }

    public var indeterminate: Bool = false {
        didSet {
            if (oldValue == indeterminate) {
                return
            }

            if (indeterminate) {
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = M_PI * 2
                rotationAnimation.duration = 1
                rotationAnimation.cumulative = true
                rotationAnimation.repeatCount = HUGE
                rotationAnimation.removedOnCompletion = false

                backgroundLayer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
            } else {
                backgroundLayer.removeAllAnimations()
            }
        }
    }

    // MARK: - Inits
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init(frame: CGRect, fillColor: UIColor) {
        self.init(frame: frame) // Calls commonInit

        backgroundLayer.fillColor = fillColor.CGColor
        progressLayer.fillColor = fillColor.CGColor
    }

    private func commonInit() {
        backgroundColor = .clearColor()
        progressLineColor = .whiteColor()
        backgroundLineColor = .whiteColor()
        indeterminateGapLength = 0.2

        setupBackgroundLayer()
        setupProgressLayer()
        setupIconLayer()
    }

    private func setupBackgroundLayer() {
        backgroundLayer.frame = bounds
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = kCALineCapRound

        if (backgroundLayer.superlayer != layer) {
            layer.addSublayer(backgroundLayer)
        }
    }

    private func setupProgressLayer() {
        progressLayer.frame = bounds
        progressLayer.lineWidth = lineWidth

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

        if (icon != nil) {
            iconLayer.contents = icon?.CGImage
        } else {
            iconLayer.contents = nil
        }

        drawBackgroundCircle()
        drawProgress()
    }

    public func drawBackgroundCircle() {
        var endAngle = CGFloat(2 * M_PI) + startAngle
        if (indeterminate) {
            endAngle = CGFloat((2 - indeterminateGapLength!) * M_PI) + startAngle
        }

        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        let radius = (bounds.size.width - lineWidth) / 2

        // Draw background
        let processBackgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundLayer.path = processBackgroundPath.CGPath
    }

    public func drawProgress() {
        let endAngle = (progress * CGFloat(2 * M_PI)) + startAngle

        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        let radius = (bounds.size.width - lineWidth) / 2

        let processPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        processPath.lineCapStyle = .Round
        progressLayer.path = processPath.CGPath
    }
}