//
//  WLoadingModalTests.swift
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

class WLoadingModalTests: QuickSpec {
    override func spec() {
        describe("WLoadingModalSpec") {
            var subject: UIViewController!
            var loadingModalView: WLoadingModal!

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                loadingModalView = nil
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(loadingModalView.backgroundColor) == .clear
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())
                    expect(loadingModalView.titleLabel.textColor) == UIColor.white
                    expect(loadingModalView.titleLabel.textAlignment) == NSTextAlignment.center
                    expect(loadingModalView.descriptionLabel.textColor) == UIColor.white
                    expect(loadingModalView.descriptionLabel.textAlignment) == NSTextAlignment.center
                    expect(loadingModalView.descriptionLabel.numberOfLines) == 0
                    expect(loadingModalView.blurEffectStyle).to(equal(UIBlurEffectStyle.dark))
                    expect(loadingModalView.blurEffectAutoResizingMask) == [.flexibleWidth, .flexibleHeight]
                    expect(loadingModalView.spinnerSize) == 44
                    expect(loadingModalView.paddingBetweenViewTopAndSpinner) == 32
                    expect(loadingModalView.paddingBetweenTitleAndSpinner) == 32
                    expect(loadingModalView.paddingBetweenDescriptionAndTitle) == 32
                    expect(loadingModalView.titleLabelHeight) == 20
                    expect(loadingModalView.descriptionLabelHeight) == 60
                }

                it("should init with coder correctly and verify commonInit") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WLoadingModal")

                    NSKeyedArchiver.archiveRootObject(loadingModalView, toFile: locToSave)

                    let loadingModalView = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WLoadingModal

                    expect(loadingModalView).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should init with coder correctly and verify commonInit") {
                    loadingModalView = WLoadingModal()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WLoadingModal")

                    NSKeyedArchiver.archiveRootObject(loadingModalView, toFile: locToSave)

                    let loadingModalView = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WLoadingModal
                    
                    expect(loadingModalView).toNot(equal(nil))

                    verifyCommonInit()
                    expect(loadingModalView.addBlurBackground) == true
                }

                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    verifyCommonInit()
                    expect(loadingModalView.addBlurBackground) == true
                    expect(loadingModalView.subviews.count) == 4
                }

                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal("Testing just title init.")

                    verifyCommonInit()
                    expect(loadingModalView.titleLabel.text) == "Testing just title init."
                    expect(loadingModalView.subviews.count) == 4
                }

                it("should successfully create a loading view without blur background") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)
                    loadingModalView.addBlurBackground = false

                    verifyCommonInit()
                    expect(loadingModalView.subviews.count) == 3
                    expect(loadingModalView.subviews.contains(loadingModalView.blurEffectView)).to(beFalsy())
                }

                it("should successfully create a loading view without blur background and be able to add it back") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)
                    loadingModalView.addBlurBackground = false

                    verifyCommonInit()
                    expect(loadingModalView.subviews.count) == 3
                    expect(loadingModalView.subviews.contains(loadingModalView.blurEffectView)).to(beFalsy())

                    loadingModalView.addBlurBackground = true
                    expect(loadingModalView.subviews.count) == 4
                    expect(loadingModalView.subviews.contains(loadingModalView.blurEffectView)).to(beTruthy())
                }

                it("should successfully create a loading view with custom settings") {
                    loadingModalView = WLoadingModal(.white,
                        title: "Unit Tests",
                        description: "Unit tests are a great resource, and everyone should love them.")

                    expect(loadingModalView.backgroundColor) == .white
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

                    let tLabel = loadingModalView.titleLabel
                    expect(tLabel.textColor) == UIColor.white
                    expect(tLabel.textAlignment) == NSTextAlignment.center
                    expect(tLabel.text).to(equal("Unit Tests"))

                    let dLabel = loadingModalView.descriptionLabel
                    expect(dLabel.textColor) == UIColor.white
                    expect(dLabel.textAlignment) == NSTextAlignment.center
                    expect(dLabel.numberOfLines) == 0
                    expect(dLabel.text).to(equal("Unit tests are a great resource, and everyone should love them."))
                }

                it("should successfully create a loading view with custom settings") {
                    loadingModalView = WLoadingModal(.white, title: "Unit Tests")

                    expect(loadingModalView.backgroundColor) == .white
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

                    let tLabel = loadingModalView.titleLabel
                    expect(tLabel.textColor) == UIColor.white
                    expect(tLabel.textAlignment) == NSTextAlignment.center
                    expect(tLabel.text).to(equal("Unit Tests"))

                    let dLabel = loadingModalView.descriptionLabel
                    expect(dLabel.textColor) == UIColor.white
                    expect(dLabel.textAlignment) == NSTextAlignment.center
                    expect(dLabel.numberOfLines) == 0
                    expect(dLabel.text).to(beNil())
                }

                it("should set the progress on the spinner") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())
                    expect(loadingModalView.spinnerView.progress).to(equal(0.15)) // Progress is set to a constant for indeterminate

                    loadingModalView.setProgress(0.6)

                    expect(loadingModalView.spinnerView.indeterminate).to(beFalsy())
                    expect(loadingModalView.spinnerView.progress).to(equal(0.6))
                }

                it("should be added and removed from the view as a subview") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    expect(subject.view.subviews.contains(loadingModalView)).to(beFalsy())
                    loadingModalView.show(subject.view, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

                    expect(subject.view.subviews.contains(loadingModalView)).to(beTruthy())

                    loadingModalView.hide()

                    expect(subject.view.subviews.contains(loadingModalView)).to(beFalsy())
                }

                it("should configure properties correctly") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    loadingModalView.spinnerSize = 11
                    loadingModalView.paddingBetweenViewTopAndSpinner = 100
                    loadingModalView.paddingBetweenTitleAndSpinner = 50
                    loadingModalView.paddingBetweenDescriptionAndTitle = 30
                    loadingModalView.titleLabelHeight = 44
                    loadingModalView.descriptionLabelHeight = 66
                    loadingModalView.blurEffectStyle = .light
                    loadingModalView.blurEffectAutoResizingMask = [.flexibleRightMargin, .flexibleTopMargin]

                    expect(loadingModalView.spinnerSize) == 11
                    expect(loadingModalView.paddingBetweenViewTopAndSpinner) == 100
                    expect(loadingModalView.paddingBetweenTitleAndSpinner) == 50
                    expect(loadingModalView.paddingBetweenDescriptionAndTitle) == 30
                    expect(loadingModalView.titleLabelHeight) == 44
                    expect(loadingModalView.descriptionLabelHeight) == 66
                    expect(loadingModalView.blurEffectStyle).to(equal(UIBlurEffectStyle.light))
                    expect(loadingModalView.blurEffectAutoResizingMask) == [.flexibleRightMargin, .flexibleTopMargin]
                }
            }
        }
    }
}
