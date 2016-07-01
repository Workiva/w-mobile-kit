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

import UIKit

public class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var presenting = true // Presenting or Dismissing (== push or pop)
    public var transitionDuration = 1.0

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // If the reference to these views does not exist, we cannot animate a transition.
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let container = transitionContext.containerView(),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }

        // Transforms we will use in the animations.
        let fromOffScreenOnRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let fromOffScreenOnLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)

        toView.transform = presenting ? fromOffScreenOnRight : fromOffScreenOnLeft

        container.addSubview(toView)

        UIView.animateWithDuration(self.transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .CurveEaseInOut,
            animations: {
                fromView.transform = self.presenting ? fromOffScreenOnLeft : fromOffScreenOnRight
                toView.transform = CGAffineTransformIdentity
            },
            completion: { finished in
                transitionContext.completeTransition(true)
                fromView.transform = CGAffineTransformIdentity
            })
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
}