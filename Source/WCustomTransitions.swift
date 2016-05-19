//
//  WCustomTransitions.swift
//  WMobileKit
// 
//  https://www.raywenderlich.com/110536/custom-uiviewcontroller-transitions
//  http://mathewsanders.com/animated-transitions-in-swift/#custom-transition-animations
//
//  Documentation for use:
//
//  Your class must provide an object which conforms to UIViewControllerTransitioningDelegate.
//    i.e. private let flipPresentAnimationController = FlipPresentAnimationController()
//
//  Your must then create a transitioning delegate, you can do this as an extension for your class.
//    i.e. extension YourViewController: UIViewControllerTransitioningDelegate { }
//
//  Finally, set your view controller's transitioning delegate to the one you created.
//    i.e. viewController.transitioningDelegate = self
//  
//  When using a navigation controller, its delegate can provide an animation controller in its
//  navigationController(_:animationControllerForOperation:fromViewController:toViewController:) method.
//
//  With a tab bar controller, its delegate can provide an animation controller in its
//  tabBarController(_:animationControllerForTransitionFromViewController:toViewController:) method.

import UIKit

public class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var presenting = true // Presenting or Dismissing

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let container = transitionContext.containerView(),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }

        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)

        toView.transform = self.presenting ? offScreenRight : offScreenLeft

        container.addSubview(toView)
        container.addSubview(fromView)

        let duration = self.transitionDuration(transitionContext)

        UIView.animateWithDuration(duration,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .CurveEaseInOut,
            animations: {
                fromView.transform = self.presenting ? offScreenLeft : offScreenRight
                toView.transform = CGAffineTransformIdentity
                },
            completion: { finished in
                transitionContext.completeTransition(true)
            })
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
}