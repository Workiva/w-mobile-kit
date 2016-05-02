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
                it("should successfully create a loading view with default settings") {
                    loadingModalView = WLoadingModal(frame: subject.view.frame)

                    expect(loadingModalView.backgroundColor) == .clearColor()
                    expect(loadingModalView.spinnerView.indeterminate).to(beTruthy())

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
                    expect(loadingModalView.spinnerView.progress).to(equal(0))

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
            }
        }
    }
}