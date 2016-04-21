//
//  WSpinner.swift
//  WMobileKit

import Foundation
import UIKit

public enum CircularProgressViewIcon {
    case None, Arrow
}

public class WSpinner: UIControl {
    // Shape Layers
    var strokeLayer = CAShapeLayer()
    var backgroundLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var iconLayer = CALayer()

    // Layer Properties
    var lineWidth: CGFloat?

    // Progress
    var progress: CGFloat?
    var indeterminate: Bool?
    var icon: CircularProgressViewIcon?
    var drawableArea: CGFloat?
    var drawableRect: CGRect?
    var arrowImage: UIImage?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init(frame: CGRect, drawableArea: CGFloat, fillColor: UIColor) {
        self.init(frame: frame)

        self.drawableArea = drawableArea
        strokeLayer.fillColor = fillColor.CGColor
    }

    private func commonInit() {
        backgroundColor = .clearColor()
        tintColor = .whiteColor()
        progress = 0
        indeterminate = false
        drawableArea = 0.75
        lineWidth = 3


        strokeLayer.frame = bounds
        strokeLayer.cornerRadius = bounds.size.width / 2
        strokeLayer.backgroundColor = superview?.backgroundColor?.CGColor

        if (strokeLayer.superlayer != layer) {
            layer.addSublayer(strokeLayer)
        }

        backgroundLayer.frame = drawableRect!
        backgroundLayer.lineWidth = lineWidth!
        backgroundLayer.strokeColor = tintColor.CGColor
        backgroundLayer.fillColor = superview?.backgroundColor?.CGColor
        backgroundLayer.lineCap = kCALineCapRound

        if (backgroundLayer.superlayer != layer) {
            layer.addSublayer(backgroundLayer)
        }
    }
}