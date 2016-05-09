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
                let verifyDefaultSettings: (Void) -> (Void) = {
                    // Verifying properties set
                    expect(loadingModalView.spinnerSize) == 44
                    expect(loadingModalView.verticalPadding) == 32
                    expect(loadingModalView.titleLabelWidth) == 120
                    expect(loadingModalView.titleLabelHeight) == 20
                    expect(loadingModalView.descriptionLabelWidth) == 180
                    expect(loadingModalView.descriptionLabelHeight) == 60

                    let tLabel: UILabel = loadingModalView.titleLabel
                    expect(tLabel.textColor) == UIColor.whiteColor()
                    expect(tLabel.textAlignment) == NSTextAlignment.Center
                    expect(tLabel.text).to(beNil())

                    let dLabel: UILabel = loadingModalView.descriptionLabel
                    expect(dLabel.textColor) == UIColor.whiteColor()
                    expect(dLabel.textAlignment) == NSTextAlignment.Center
                    expect(dLabel.numberOfLines) == 0
                    expect(dLabel.text).to(beNil())
                }

                it("should init with coder correctly and verify commonInit") {
                    loadingModalView = WLoadingModal()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WLoadingModal")

                    NSKeyedArchiver.archiveRootObject(pagingSelectorControl, toFile: locToSave)

                    let loadingModalView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WLoadingModal
                    
                    expect(loadingModalView).toNot(equal(nil))

                    verifyDefaultSettings()
                }

                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    expect(loadingModalView.backgroundColor) == .clearColor()
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

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
                    loadingModalView.verticalPadding = 22
                    loadingModalView.titleLabelWidth = 33
                    loadingModalView.titleLabelHeight = 44
                    loadingModalView.descriptionLabelWidth = 55
                    loadingModalView.descriptionLabelHeight = 66

                    expect(loadingModalView.spinnerSize) == 11
                    expect(loadingModalView.verticalPadding) == 22
                    expect(loadingModalView.titleLabelWidth) == 33
                    expect(loadingModalView.titleLabelHeight) == 44
                    expect(loadingModalView.descriptionLabelWidth) == 55
                    expect(loadingModalView.descriptionLabelHeight) == 66
                }
            }
        }
    }
}