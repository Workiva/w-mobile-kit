//
//  WCustomTransitionsTests.swift
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
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

                window = UIWindow(frame: UIScreen.main.bounds)
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
                    expect(animationController.transitionDuration) == 1.0
                }

                it("should perform animation without crash when presenting") {
                    // All the views have to be set up in WCustomTransitioningContext in
                    // order to hit coverage requirement, this just verifies we do not crash.
                    let transitioningContext = WCustomTransitioningContext()
                    animationController.animateTransition(using: transitioningContext)
                }

                it("should perform animation without crash when disappearing") {
                    animationController.presenting = false

                    // All the views have to be set up in WCustomTransitioningContext in
                    // order to hit coverage requirement, this just verifies we do not crash.
                    let transitioningContext = WCustomTransitioningContext()
                    animationController.animateTransition(using: transitioningContext)
                }

                it("should allow transition duration to be set") {
                    expect(animationController.transitionDuration) == 1.0

                    animationController.transitionDuration = 0.8

                    expect(animationController.transitionDuration) == 0.8
                }
            }
        }
    }
}

class WCustomTransitioningContext: NSObject, UIViewControllerContextTransitioning {
    let cView = UIView()
    let firstVC = UIViewController()

    var containerView: UIView {
        return cView
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return firstVC
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return firstVC.view
    }

    func initialFrame(for vc: UIViewController) -> CGRect {
        return CGRect.zero
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        return CGRect.zero
    }

    var isAnimated:  Bool {
        return false
    }

    var isInteractive: Bool {
        return false
    }

    var presentationStyle: UIModalPresentationStyle {
        return .none
    }

    func completeTransition(_ didComplete: Bool) {}

    func updateInteractiveTransition(_ percentComplete: CGFloat) {}

    func finishInteractiveTransition() {}

    func cancelInteractiveTransition() {}

    var transitionWasCancelled: Bool {
        return true
    }

    var targetTransform: CGAffineTransform {
        return CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 0, ty: 0)
    }

    func pauseInteractiveTransition() { }
}
