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

import UIKit

open class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    open var presenting = true // Presenting or Dismissing (== push or pop)
    open var transitionDuration = 1.0

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // If the reference to these views does not exist, we cannot animate a transition.
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }

        let container = transitionContext.containerView

        // Transforms we will use in the animations.
        let fromOffScreenOnRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let fromOffScreenOnLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)

        toView.transform = presenting ? fromOffScreenOnRight : fromOffScreenOnLeft

        container.addSubview(toView)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: UIView.AnimationOptions(),
            animations: {
                fromView.transform = self.presenting ? fromOffScreenOnLeft : fromOffScreenOnRight
                toView.transform = CGAffineTransform.identity
            },
            completion: { finished in
                transitionContext.completeTransition(true)
                fromView.transform = CGAffineTransform.identity
            })
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
}
