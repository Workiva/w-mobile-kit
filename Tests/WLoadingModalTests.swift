//
//  WLoadingModalTests.swift
//  WMobileKit

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

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                loadingModalView = nil
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(loadingModalView.backgroundColor) == UIColor(hex: 0x595959, alpha: 0.85)
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())
                    expect(loadingModalView.titleLabel.textColor) == UIColor.whiteColor()
                    expect(loadingModalView.titleLabel.textAlignment) == NSTextAlignment.Center
                    expect(loadingModalView.descriptionLabel.textColor) == UIColor.whiteColor()
                    expect(loadingModalView.descriptionLabel.textAlignment) == NSTextAlignment.Center
                    expect(loadingModalView.descriptionLabel.numberOfLines) == 0
                }

                let verifyDefaultSettings = {
                    // Verifying properties set
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
                    let locToSave = path.stringByAppendingPathComponent("WLoadingModal")

                    NSKeyedArchiver.archiveRootObject(loadingModalView, toFile: locToSave)

                    let loadingModalView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WLoadingModal

                    expect(loadingModalView).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should init with coder correctly and verify commonInit") {
                    loadingModalView = WLoadingModal()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WLoadingModal")

                    NSKeyedArchiver.archiveRootObject(loadingModalView, toFile: locToSave)

                    let loadingModalView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WLoadingModal
                    
                    expect(loadingModalView).toNot(equal(nil))

                    verifyDefaultSettings()
                }

                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    expect(loadingModalView.backgroundColor) == UIColor(hex: 0x595959, alpha: 0.85)
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

                    verifyDefaultSettings()
                }

                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal("Testing just title init.")

                    verifyDefaultSettings()
                }

                it("should successfully create a loading view with custom settings") {
                    loadingModalView = WLoadingModal(.whiteColor(),
                        title: "Unit Tests",
                        description: "Unit tests are a great resource, and everyone should love them.")

                    expect(loadingModalView.backgroundColor) == .whiteColor()
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

                    let tLabel = loadingModalView.titleLabel
                    expect(tLabel.textColor) == UIColor.whiteColor()
                    expect(tLabel.textAlignment) == NSTextAlignment.Center
                    expect(tLabel.text).to(equal("Unit Tests"))

                    let dLabel = loadingModalView.descriptionLabel
                    expect(dLabel.textColor) == UIColor.whiteColor()
                    expect(dLabel.textAlignment) == NSTextAlignment.Center
                    expect(dLabel.numberOfLines) == 0
                    expect(dLabel.text).to(equal("Unit tests are a great resource, and everyone should love them."))
                }

                it("should successfully create a loading view with custom settings") {
                    loadingModalView = WLoadingModal(.whiteColor(), title: "Unit Tests")

                    expect(loadingModalView.backgroundColor) == .whiteColor()
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

                    let tLabel = loadingModalView.titleLabel
                    expect(tLabel.textColor) == UIColor.whiteColor()
                    expect(tLabel.textAlignment) == NSTextAlignment.Center
                    expect(tLabel.text).to(equal("Unit Tests"))

                    let dLabel = loadingModalView.descriptionLabel
                    expect(dLabel.textColor) == UIColor.whiteColor()
                    expect(dLabel.textAlignment) == NSTextAlignment.Center
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

                    expect(loadingModalView.spinnerSize) == 11
                    expect(loadingModalView.paddingBetweenViewTopAndSpinner) == 100
                    expect(loadingModalView.paddingBetweenTitleAndSpinner) == 50
                    expect(loadingModalView.paddingBetweenDescriptionAndTitle) == 30
                    expect(loadingModalView.titleLabelHeight) == 44
                    expect(loadingModalView.descriptionLabelHeight) == 66
                }
            }
        }
    }
}