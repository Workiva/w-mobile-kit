//
//  WCustomTransitionsTests.swift
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

                animationController = SlideAnimationController()
            })

            afterEach({
                animationController = nil
            })

            describe("when app has been init") {
                it("should init") {
                    expect(animationController.presenting).to(beTruthy())
                    expect(animationController.transitionDuration(nil)) == 1.0
                }

                it("should perform animation without crash when presenting") {
                    // All the views have to be set up in WCustomTransitioningContext in
                    // order to hit coverage requirement, this just verifies we do not crash.
                    let transitioningContext = WCustomTransitioningContext()
                    animationController.animateTransition(transitioningContext)
                }

                it("should perform animation without crash when disappearing") {
                    animationController.presenting = false

                    // All the views have to be set up in WCustomTransitioningContext in
                    // order to hit coverage requirement, this just verifies we do not crash.
                    let transitioningContext = WCustomTransitioningContext()
                    animationController.animateTransition(transitioningContext)
                }

                it("should allow transition duration to be set") {
                    expect(animationController.transitionDuration(nil)) == 1.0

                    animationController.transitionDuration = 0.8

                    expect(animationController.transitionDuration(nil)) == 0.8
                }
            }
        }
    }
}

class WCustomTransitioningContext: NSObject, UIViewControllerContextTransitioning {
    let cView = UIView()
    let firstVC = UIViewController()

    func containerView() -> UIView? {
        return cView
    }

    func viewControllerForKey(key: String) -> UIViewController? {
        return firstVC
    }

    func viewForKey(key: String) -> UIView? {
        return firstVC.view
    }

    func initialFrameForViewController(vc: UIViewController) -> CGRect {
        return CGRectZero
    }

    func finalFrameForViewController(vc: UIViewController) -> CGRect {
        return CGRectZero
    }

    func isAnimated() -> Bool {
        return false
    }

    func isInteractive() -> Bool {
        return false
    }

    func presentationStyle() -> UIModalPresentationStyle {
        return .None
    }

    func completeTransition(didComplete: Bool) {}

    func updateInteractiveTransition(percentComplete: CGFloat) {}

    func finishInteractiveTransition() {}

    func cancelInteractiveTransition() {}

    func transitionWasCancelled() -> Bool {
        return true
    }

    func targetTransform() -> CGAffineTransform {
        return CGAffineTransformMake(0, 0, 0, 0, 0, 0)
    }
}