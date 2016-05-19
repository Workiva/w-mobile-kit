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

                it("should perform our animation on navigation controller") {
                    animationController = SlideAnimationController()

                    // All the views have to be set up in WCustomTransitioningContext in
                    // order to hit coverage requirement, this just verifies we do not crash.
                    let transitioningContext = WCustomTransitioningContext()
                    animationController.animateTransition(transitioningContext)
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