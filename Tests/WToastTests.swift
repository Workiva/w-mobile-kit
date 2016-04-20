//
//  WToastTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WToastSpec: QuickSpec {
    override func spec() {
        describe("WToastSpec") {
            var subject: UIViewController!
            var toastView: WToastView!

            let message1 = "Message 1"
            let message2 = "Message 2"
            let message3 = "Message 3"
            let message4 = "Message 4"

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                WToastManager.sharedInstance.rootWindow = window
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                // Init the singleton
                WToastManager.sharedInstance
            })

            afterEach({
                // Reset shared instance
                WToastManager.sharedInstance.currentToast = nil
            })

            describe("when app has been init") {
                it("should successfully add and display a toast view with default settings") {
                    toastView = WToastView(message: message1)

                    WToastManager.sharedInstance.showToast(toastView)

                    // public properties
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.message).to(equal(message1))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))
                }
            }
        }
    }
}