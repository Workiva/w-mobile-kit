//
//  WSpinnerTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WSpinnerTests: QuickSpec {
    let whiteColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.75)
    let greyColor: UIColor = UIColor(hex: 0xbfe4ff, alpha: 0.45)
    let startAngle = -CGFloat(M_PI / 2)

    override func spec() {
        describe("WSpinnerSpec") {
            var subject: UIViewController!
            var spinnerView: WSpinner!

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                spinnerView = nil
            })

            describe("when app has been init") {
                it("should successfully add and display a spinner view with default settings") {
                    spinnerView = WSpinner()

                    subject.view.addSubview(spinnerView)
                    spinnerView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    // Initial colors should be set to the default
                    expect(spinnerView.backgroundColor) == .clearColor()
                    expect(spinnerView.progressLayer.strokeColor) == self.whiteColor.CGColor
                    expect(spinnerView.backgroundLayer.strokeColor) == self.greyColor.CGColor

                    // Background layer should be configured to the default
                    let bLayer = spinnerView.backgroundLayer
                    expect(bLayer.frame) == CGRectZero
                    expect(bLayer.fillColor) == UIColor.clearColor().CGColor
                    expect(bLayer.lineWidth) == 3
                    expect(bLayer.lineCap) == kCALineCapRound

                    // Progress layer should be configured to the default
                    let pLayer = spinnerView.progressLayer
                    expect(pLayer.frame) == CGRectZero
                    expect(pLayer.lineWidth) == 3
                    expect(pLayer.lineCap) == kCALineCapRound

                    // Icon layer should be configured to the default
                    let iLayer = spinnerView.iconLayer
                    expect(iLayer.frame) == CGRectZero

                    // Draw view
                    spinnerView.setNeedsDisplay()
                    spinnerView.drawRect(spinnerView.bounds)

                    // Icon layer should be configured correctly following drawing
                    expect(iLayer.frame) == spinnerView.bounds
                    expect(spinnerView.progress) == 0

                    // Background layer should be configured correctly following drawing
                    expect(bLayer.frame) == spinnerView.bounds
                    let bEndAngle = CGFloat(2 * M_PI) + self.startAngle
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: self.startAngle, endAngle: bEndAngle, clockwise: true).CGPath

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    let pEndAngle = (0 * CGFloat(2 * M_PI)) + self.startAngle
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: self.startAngle, endAngle: pEndAngle, clockwise: true).CGPath
                }

                it("should successfully add and display an indeterminate spinner view with default settings") {
                    spinnerView = WSpinner()
                    spinnerView.indeterminate = true

                    subject.view.addSubview(spinnerView)
                    spinnerView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    // Initial colors should be set to the default
                    expect(spinnerView.backgroundColor) == .clearColor()
                    expect(spinnerView.progressLayer.strokeColor) == self.whiteColor.CGColor
                    expect(spinnerView.backgroundLayer.strokeColor) == self.greyColor.CGColor

                    // Background layer should be configured to the default
                    let bLayer = spinnerView.backgroundLayer
                    expect(bLayer.frame) == CGRectZero
                    expect(bLayer.fillColor) == UIColor.clearColor().CGColor
                    expect(bLayer.lineWidth) == 3
                    expect(bLayer.lineCap) == kCALineCapRound

                    // Progress layer should be configured to the default
                    let pLayer = spinnerView.progressLayer
                    expect(pLayer.frame) == CGRectZero
                    expect(pLayer.lineWidth) == 3
                    expect(pLayer.lineCap) == kCALineCapRound

                    // Progress layer should have an animation
                    let expectedAnimation: CABasicAnimation = pLayer.animationForKey("rotationAnimation") as! CABasicAnimation
                    expect(expectedAnimation.toValue as? Double) == M_PI * 2
                    expect(expectedAnimation.duration) == 1.2
                    expect(expectedAnimation.cumulative).to(beTruthy())
                    expect(expectedAnimation.repeatCount) == HUGE
                    expect(expectedAnimation.removedOnCompletion).to(beFalsy())

                    // Icon layer should be configured to the default
                    let iLayer = spinnerView.iconLayer
                    expect(iLayer.frame) == CGRectZero

                    // Draw view
                    spinnerView.setNeedsDisplay()
                    spinnerView.drawRect(spinnerView.bounds)

                    // Icon layer should be configured correctly following drawing
                    expect(iLayer.frame) == spinnerView.bounds
                    expect(spinnerView.progress) == 0

                    // Background layer should be configured correctly following drawing
                    expect(bLayer.frame) == spinnerView.bounds
                    let bEndAngle = CGFloat(2 * M_PI) + self.startAngle
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: self.startAngle, endAngle: bEndAngle, clockwise: true).CGPath

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    var pEndAngle = CGFloat(0.5 * M_PI) + self.startAngle
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: self.startAngle, endAngle: pEndAngle, clockwise: true).CGPath

                    // Should have a different progress layer path with a different indeterminate section length
                    spinnerView.indeterminateSectionLength = 0.75
                    spinnerView.drawProgress()
                    pEndAngle = CGFloat(1.5 * M_PI) + self.startAngle
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: self.startAngle, endAngle: pEndAngle, clockwise: true).CGPath
                }

                it("should successfully add and display a progress spinner view with custom settings") {
                    spinnerView = WSpinner()
                    spinnerView.indeterminate = true // Should be overridden by progress
                    spinnerView.progress = 0.25
                    spinnerView.backgroundColor = .whiteColor()
                    spinnerView.progressLineColor = .blueColor()
                    spinnerView.backgroundLineColor = .blueColor()
                    spinnerView.lineWidth = 1

                    subject.view.addSubview(spinnerView)
                    spinnerView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    // Custom colors should not be overridden by default
                    expect(spinnerView.backgroundColor) == .whiteColor()
                    expect(spinnerView.progressLayer.strokeColor) == UIColor.blueColor().CGColor
                    expect(spinnerView.backgroundLayer.strokeColor) == UIColor.blueColor().CGColor

                    // Background layer
                    let bLayer = spinnerView.backgroundLayer
                    expect(bLayer.frame) == CGRectZero
                    expect(bLayer.fillColor) == UIColor.clearColor().CGColor
                    expect(bLayer.lineWidth) == 1
                    expect(bLayer.lineCap) == kCALineCapRound

                    // Progress layer
                    let pLayer = spinnerView.progressLayer
                    expect(pLayer.frame) == CGRectZero
                    expect(pLayer.lineWidth) == 1
                    expect(pLayer.lineCap) == kCALineCapRound

                    // Icon layer should be still configured to the default
                    let iLayer = spinnerView.iconLayer
                    expect(iLayer.frame) == CGRectZero

                    // Draw view
                    spinnerView.setNeedsDisplay()
                    spinnerView.drawRect(spinnerView.bounds)

                    // Icon layer should be configured correctly following drawing
                    expect(iLayer.frame) == spinnerView.bounds
                    expect(spinnerView.progress) == 0.25

                    // Background layer should be configured correctly following drawing
                    expect(bLayer.frame) == spinnerView.bounds
                    let bEndAngle = CGFloat(2 * M_PI) + self.startAngle
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 1) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: self.startAngle, endAngle: bEndAngle, clockwise: true).CGPath

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    let pEndAngle = (0.25 * CGFloat(2 * M_PI)) + self.startAngle
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 1) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: self.startAngle, endAngle: pEndAngle, clockwise: true).CGPath
                }
            }
        }
    }
}