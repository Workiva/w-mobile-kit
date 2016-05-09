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

        // prepare the toView for the animation
        toView.transform = self.presenting ? offScreenRight : offScreenLeft

        // set the anchor point so that rotations happen from the top-left corner
        toView.layer.anchorPoint = CGPoint(x:0, y:0)
        fromView.layer.anchorPoint = CGPoint(x:0, y:0)

        // updating the anchor point also moves the position to we have to move the center position to the top-left to compensate
        toView.layer.position = CGPoint(x:0, y:0)
        fromView.layer.position = CGPoint(x:0, y:0)

        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)

        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(transitionContext)

        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animateWithDuration(duration,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .CurveEaseInOut,
            animations: {
                // slide fromView off either the left or right edge of the screen
                // depending if we're presenting or dismissing this view
                fromView.transform = self.presenting ? offScreenLeft : offScreenRight
                toView.transform = CGAffineTransformIdentity

                },
            completion: { finished in
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
            })
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
}