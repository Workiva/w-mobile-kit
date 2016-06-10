//
//  WSpinnerTests.swift
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

import Quick
import Nimble
@testable import WMobileKit

class WSpinnerTests: QuickSpec {
    override func spec() {
        describe("WSpinnerSpec") {
            var subject: UIViewController!
            var spinnerView: WSpinner!

            let whiteColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.75)
            let greyColor: UIColor = UIColor(hex: 0xbfe4ff, alpha: 0.45)
            let startAngle = -CGFloat(M_PI / 2)
            let endAngle = CGFloat(2 * M_PI) + startAngle

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
                    expect(spinnerView.progressLayer.strokeColor) == whiteColor.CGColor
                    expect(spinnerView.backgroundLayer.strokeColor) == greyColor.CGColor

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
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false).CGPath
                    expect(bLayer.strokeEnd) == 1

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
                    expect(pLayer.strokeEnd) == 0
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
                    expect(spinnerView.progressLayer.strokeColor) == whiteColor.CGColor
                    expect(spinnerView.backgroundLayer.strokeColor) == greyColor.CGColor

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

                    // Both layer should have an animation
                    let verifyRotationAnimation = {
                        (animation: CABasicAnimation) -> Void in

                        expect(animation.toValue as? Double) == M_PI * 2
                        expect(animation.duration) == 1.4
                        expect(animation.cumulative).to(beTruthy())
                        expect(animation.repeatCount) == HUGE
                        expect(animation.removedOnCompletion).to(beFalsy())
                    }

                    verifyRotationAnimation(bLayer.animationForKey("rotationAnimation") as! CABasicAnimation)
                    verifyRotationAnimation(pLayer.animationForKey("rotationAnimation") as! CABasicAnimation)

                    // Icon layer should be configured to the default
                    let iLayer = spinnerView.iconLayer
                    expect(iLayer.frame) == CGRectZero

                    // Draw view
                    spinnerView.setNeedsDisplay()
                    spinnerView.drawRect(spinnerView.bounds)

                    // Icon layer should be configured correctly following drawing
                    expect(iLayer.frame) == spinnerView.bounds
                    expect(spinnerView.progress) == 0.15 // indeterminate progress set to 0.15

                    // Background layer should be configured correctly following drawing
                    expect(bLayer.frame) == spinnerView.bounds
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false).CGPath
                    expect(bLayer.strokeEnd) == 1 - 0.15

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 3) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
                    expect(pLayer.strokeEnd) == 0.15

                    // Should have a different progress layer path with a different indeterminate section length
                    spinnerView.indeterminateSectionLength = 0.3
                    expect(spinnerView.progress) == 0.30
                    spinnerView.drawProgress()
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
                    expect(pLayer.strokeEnd) == 0.3
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
                    let bCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let bRadius = (spinnerView.bounds.size.width - 1) / 2
                    expect(bLayer.path) == UIBezierPath(arcCenter: bCenter, radius: bRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false).CGPath
                    expect(bLayer.strokeEnd) == 1 - 0.25

                    // Progress layer should be configured correctly following drawing
                    expect(pLayer.frame) == spinnerView.bounds
                    let pCenter = CGPointMake(spinnerView.bounds.size.width / 2, spinnerView.bounds.size.height / 2)
                    let pRadius = (spinnerView.bounds.size.width - 1) / 2
                    expect(pLayer.path) == UIBezierPath(arcCenter: pCenter, radius: pRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
                    expect(pLayer.strokeEnd) == 0.25
                }

                it("should set progress to 1 and never above") {
                    spinnerView = WSpinner()

                    expect(spinnerView.progress) == 0
                    spinnerView.progress = 1.5
                    expect(spinnerView.progress) == 1.0
                }
            }
        }
    }
}