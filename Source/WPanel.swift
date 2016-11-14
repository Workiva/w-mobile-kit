//
//  WPanel.swift
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

import Foundation
import UIKit
import SnapKit

public class WPanel: UIView {
    var headerView: UIView?
    var headerHeight = 0

    var topDragLine = UIView()
    var bottomDragLine = UIView()

    public var dragLineWidth: CGFloat = 60.0
    public var containerView = UIView()

    public var pages: [UIViewController]? {
        didSet {
            setupUI()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        setupUI()
    }

    public convenience init() {
        self.init(frame: CGRectZero)
    }

    public func commonInit() {
        backgroundColor = .whiteColor()

        addSubview(containerView)

        addSubview(topDragLine)
        addSubview(bottomDragLine)

        topDragLine.backgroundColor = .grayColor()
        bottomDragLine.backgroundColor = .grayColor()

        layer.cornerRadius = 5
        clipsToBounds = true
    }

    public func setupUI() {
        containerView.snp_remakeConstraints { (make) in
            make.edges.equalTo(self)
        }

        topDragLine.snp_remakeConstraints { (make) in
            make.top.equalTo(self).offset(3)
            make.width.equalTo(dragLineWidth)
            make.centerX.equalTo(self)
            make.height.equalTo(1)
        }

        bottomDragLine.snp_remakeConstraints { (make) in
            make.top.equalTo(topDragLine.snp_bottom).offset(3)
            make.height.equalTo(topDragLine)
            make.centerX.equalTo(topDragLine)
            make.width.equalTo(topDragLine)
        }

        layoutIfNeeded()
    }
}

public class WPanelVC: WSideMenuContentVC {
    public var panelView = WPanel()
    public var floatingButton = WFAButton()
    public var panInterceptView = UIView()
    public var backgroundTapView = UIView()

    var topConstraint: Constraint?
    var originalYOffset: CGFloat?
    var initialYOffset: CGFloat?

    // Height Ratios for snapping, values can be any non-negative value where 1.0 equals full height of the view controller's view
    public var snapHeights: [CGFloat] = [0.0, 0.4, 0.96]
    public var pages: [WPage]?
    // Cap value on how far user can drag the panel up before it snaps back to heighest value in snapHeights
    // 0.0 means no "rubber band" effect, 1.0 means they can drag as far as they want until it snaps back
    public var springValuePastMaxHeight: CGFloat = 0.02

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    public func commonInit() {
        backgroundTapView.hidden = true

        floatingButton.icon = UIImage(named: "drawer")
        floatingButton.addTarget(self, action: #selector(WPanelVC.floatingButtonWasPressed(_:)), forControlEvents: .TouchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(_:)))
        panInterceptView.addGestureRecognizer(tapRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasPanned(_:)))
        panInterceptView.addGestureRecognizer(panRecognizer)
        let tapHideRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(_:)))
        tapHideRecognizer.cancelsTouchesInView = false
        backgroundTapView.addGestureRecognizer(tapHideRecognizer)
    }

    public func setupUI() {
        view.addSubview(backgroundTapView)
        view.addSubview(floatingButton)
        view.addSubview(panelView)
        view.addSubview(panInterceptView)

        let initialSnapRatio = getSmallestSnapRatio()
        originalYOffset = view.frame.height * initialSnapRatio

        backgroundTapView.snp_remakeConstraints { (make) in
            make.edges.equalTo(view)
        }

        panelView.snp_remakeConstraints { (make) in
            make.width.equalTo(view).offset(-20)
            make.centerX.equalTo(view)
            topConstraint = make.top.equalTo(view.snp_bottom).offset(-originalYOffset!).constraint
            make.bottom.equalTo(view).offset(5)
        }

        panInterceptView.snp_remakeConstraints { (make) in
            make.width.equalTo(panelView)
            make.top.equalTo(panelView).offset(-30)
            make.bottom.equalTo(panelView.snp_top).offset(20)
            make.centerX.equalTo(panelView)
        }

        floatingButton.snp_remakeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
            make.height.width.equalTo(50)
        }

        view.layoutIfNeeded()
    }

    func panelWasPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began, .Changed:
            let yLocation = recognizer.locationInView(view).y
            var yOffset = view.frame.height - yLocation
            let heightRatio: CGFloat = yOffset / view.frame.height
            let largestRatio = getLargestSnapRatio()

            if (heightRatio > largestRatio) {
                // Calculate how far to "spring" if user pulls above the max allowed height
                let cappedYOffset = view.frame.height * largestRatio
                let largestHeight = largestRatio * view.frame.height
                let heightDiff = view.frame.height - largestHeight
                let subRatioToFullHeight = (min(yOffset, view.frame.height) - largestHeight) / heightDiff
                let springRatio = subRatioToFullHeight * springValuePastMaxHeight
                let springOffsetAddition = springRatio * view.frame.height

                yOffset = cappedYOffset + springOffsetAddition
            }

            if (topConstraint != nil) {
                topConstraint!.updateOffset(-yOffset)
            }
            view.layoutIfNeeded()
        case .Ended, .Cancelled, .Failed:
            // Did the user just tap it, or did they move it
            let yLocation = recognizer.locationInView(view).y
            let yOffset = view.frame.height - yLocation
            let currentSnapRatio: CGFloat = yOffset / view.frame.height

            // Check which snap point is closest
            var closestSnapRatio: CGFloat?
            var distance: CGFloat = 1.0
            for ratio in snapHeights {
                let currDistance = fabs(ratio - currentSnapRatio)
                if (currDistance < distance || closestSnapRatio == nil) {
                    distance = currDistance
                    closestSnapRatio = ratio
                }
            }

            // In the case of no ratios existing, force it to snap to 0.0 (hidden)
            closestSnapRatio = closestSnapRatio ?? 0.0

            // Check velocity of pan if user is flinging panel up or down
            let yVelocity = -recognizer.velocityInView(view).y
            if (yVelocity > 150 && currentSnapRatio > closestSnapRatio) {
                if let nextRatio = getNextSnapRatio(closestSnapRatio!) {
                    closestSnapRatio = nextRatio
                }
            } else if (yVelocity < -150 && currentSnapRatio < closestSnapRatio) {
                if let prevRatio = getPreviousSnapRatio(closestSnapRatio!) {
                    closestSnapRatio = prevRatio
                }
            }

            movePanelToSnapRatio(closestSnapRatio!, animated: true)
        default:
            break
        }
    }

    func panelWasTapped(recognizer: UIPanGestureRecognizer) {
        movePanelToSnapRatio(snapHeights[0], animated: true)
    }

    // Snap Height Helpers
    func getNextSnapRatio(fromRatio: CGFloat) -> CGFloat? {
        var returnRatio: CGFloat?
        var nextHighest: CGFloat = 1.0
        for ratio in snapHeights {
            if (ratio > fromRatio && ratio <= nextHighest) {
                nextHighest = ratio
                returnRatio = nextHighest
            }
        }

        return returnRatio
    }

    func getPreviousSnapRatio(fromRatio: CGFloat) -> CGFloat? {
        var returnRatio: CGFloat?
        var previousLowest: CGFloat = 0.0
        for ratio in snapHeights {
            if (ratio < fromRatio && ratio >= previousLowest) {
                previousLowest = ratio
                returnRatio = previousLowest
            }
        }

        return returnRatio
    }

    func getSmallestSnapRatio() -> CGFloat {
        var smallestRatio: CGFloat = 1.0

        for ratio in snapHeights {
            if (ratio <= smallestRatio) {
                smallestRatio = ratio
            }
        }

        return smallestRatio
    }

    func getLargestSnapRatio() -> CGFloat {
        var largestRatio: CGFloat = 0.0

        for ratio in snapHeights {
            if (ratio >= largestRatio) {
                largestRatio = ratio
            }
        }

        return largestRatio
    }

    func movePanelToSnapRatio(ratio: CGFloat, animated: Bool = false) {
        // Get actual height
        let snapRatioOffset = view.frame.height * ratio

        // Need to layout any pending changes before animation
        view.layoutIfNeeded()

        if (topConstraint != nil) {
            topConstraint!.updateOffset(-snapRatioOffset)
        }

        if (animated) {
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut,
                animations: {
                    self.view.layoutIfNeeded()
                },
                completion: nil
            )
        } else {
            view.layoutIfNeeded()
        }

        floatingButton.hidden = ratio > 0.0
        backgroundTapView.hidden = ratio == 0.0
    }

    func floatingButtonWasPressed(sender: WFAButton) {
        movePanelToSnapRatio(snapHeights[1], animated: true)
    }
}
