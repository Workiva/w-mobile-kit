//
//  WCustomTransitionsTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WCustomTransitionsTests: QuickSpec {
    override func spec() {
        describe("WCustomTransitionsSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var animationController: SlideAnimationController!

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                animationController = nil
            })

            describe("when app has been init") {
                it("should init") {
                    animationController = SlideAnimationController()

                    expect(animationController.presenting).to(beTruthy())
                    expect(animationController.transitionDuration(nil)) == 1.0
                }
            }
        }
    }
}