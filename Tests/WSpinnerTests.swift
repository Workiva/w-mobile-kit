//
//  WSpinnerTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WSpinnerTests: QuickSpec {
    let whiteColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.75)
    let greyColor: UIColor = UIColor(hex: 0xbfe4ff, alpha: 0.45)

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

                    subject.view.layoutIfNeeded()

                    // Initial colors should be set to the default
                    expect(spinnerView.backgroundColor) == UIColor.clearColor()
                    expect(spinnerView.progressLineColor) == self.whiteColor
                    expect(spinnerView.backgroundLineColor) == self.greyColor

                    // Background layer should be configured to the default
//                    expect(spinnerView.backgroundLayer.frame).to(equal(spinnerView.bounds))
//                    expect(spinnerView.backgroundLayer.fillColor!) = UIColor.clearColor().CGColor

                    // Progress layer should be configured to the default

                    // Icon layer should be configured to the default
                }
            }
        }
    }
}