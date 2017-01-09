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

protocol WPanelPageManagerDelegate: class {
    func wPanelPageManager(pageManager: WPanelPageManagerVC, didUpdatePageCount count: Int)
    func wPanelPageManager(pageManager: WPanelPageManagerVC, didUpdatePageIndex index: Int)
}

public protocol WPanelDelegate: class {
    func isSidePanel() -> Bool
    func setPanelRatio(ratio: CGFloat, animated: Bool)
    func setPanelOffset(value: CGFloat, animated: Bool)
}

public class WPanel: UIView {
    var topDragLine = UIView()
    var bottomDragLine = UIView()

    public var dragLineWidth: CGFloat = 60.0
    public var containerView = UIView()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRectZero)
    }

    public func commonInit() {
        backgroundColor = .clearColor()
        containerView.backgroundColor = .whiteColor()

        addSubview(containerView)
        addSubview(topDragLine)
        addSubview(bottomDragLine)

        topDragLine.backgroundColor = .grayColor()
        bottomDragLine.backgroundColor = .grayColor()

        clipsToBounds = true

        setupUI()
    }

    public func setupUI() {
        let cornerRadius = layer.cornerRadius
        containerView.snp_remakeConstraints { (make) in
            make.left.right.width.top.equalTo(self)
            make.bottom.equalTo(self).offset(-cornerRadius)
        }

        topDragLine.snp_remakeConstraints { (make) in
            make.top.equalTo(self).offset(6)
            make.width.equalTo(dragLineWidth)
            make.centerX.equalTo(self)
            make.height.equalTo(1)
        }

        bottomDragLine.snp_remakeConstraints { (make) in
            make.top.equalTo(topDragLine.snp_bottom).offset(4)
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
    public var contentContainerView = UIView()

    // Will either be side or top constraint to move the panel
    var mutableConstraint: Constraint?

    // Controls the constraint for the movement of the panel
    public var currentPanelOffset: CGFloat = 0 {
        didSet {
            mutableConstraint?.updateOffset(-currentPanelOffset)
        }
    }

    var currentPanelRatio: CGFloat = 0

    // This is calculated by modifying sidePanelCoversContentAtWidth
    private(set) var sidePanelCoversContent = true

    // Width value in which if window width is greater than this value, panel will become side panel instead of bottom panel
    // Set this to CGFloat.max if you never want the panel to switch to the side panel
    public var widthCapForSidePanel: CGFloat = 675 {
        didSet {
            setupUI()
        }
    }

    // Width value in which if window width is greater than this value, side panel will cover content
    // Set this to CGFloat.max if you never want the panel to cover content
    public var sidePanelCoversContentUpToWidth: CGFloat = 1023 {
        didSet {
            setupUI()
        }
    }

    // Width of the panel
    public var sidePanelWidth: CGFloat = 380 {
        didSet {
            setupUI()
        }
    }

    // Height Ratios for snapping, values can be any non-negative value where 1.0 equals full height of the view controller's view
    public var snapHeights: [CGFloat] = [0.0, 0.4, 0.96]

    // Cap value on how far user can drag the panel up before it snaps back to heighest value in snapHeights
    // 0.0 means no "rubber band" effect, 1.0 means they can drag as far as they want until it snaps back
    public var springValuePastMaxHeight: CGFloat = 0.02

    // Can set border/outline properties on the panel from the view controller for convenience
    public var outlineWidth: CGFloat = 0.5 {
        didSet {
            panelView.layer.borderWidth = outlineWidth
        }
    }
    public var outlineColor: CGColor = UIColor.lightGrayColor().CGColor {
        didSet {
            panelView.layer.borderColor = outlineColor
        }
    }

    public var velocityForSwipe: CGFloat = 150

    // Corner radius on the panel view
    public var cornerRadius: CGFloat = 5 {
        didSet {
            panelView.layer.cornerRadius = cornerRadius
            setupUI()
        }
    }

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

        currentPanelRatio = getSmallestSnapRatio()
        currentPanelOffset = view.frame.height * currentPanelRatio
        panInterceptView.hidden = true
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setupUI()
    }

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition(
            { (context) in
                self.setupUI()
            },
            completion: nil
        )
    }

    public func commonInit() {
        floatingButton.addTarget(self, action: #selector(WPanelVC.floatingButtonWasPressed(_:)), forControlEvents: .TouchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(_:)))
        tapRecognizer.cancelsTouchesInView = false
        panInterceptView.addGestureRecognizer(tapRecognizer)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasPanned(_:)))
        panRecognizer.cancelsTouchesInView = false
        panInterceptView.addGestureRecognizer(panRecognizer)

        let tapHideRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(_:)))
        tapHideRecognizer.cancelsTouchesInView = false
        contentContainerView.addGestureRecognizer(tapHideRecognizer)
    }

    public func setupUI() {
        view.addSubview(contentContainerView)
        view.addSubview(floatingButton)
        view.addSubview(panelView)
        view.addSubview(panInterceptView)

        panelView.layer.borderWidth = outlineWidth
        panelView.layer.borderColor = outlineColor

        panelView.snp_removeConstraints()

        sidePanelCoversContent = view.frame.width <= sidePanelCoversContentUpToWidth

        if (sidePanel()) {
            currentPanelOffset = currentPanelOffset > 0.0 ? sidePanelWidth : 0.0
            currentPanelRatio = currentPanelOffset > 0.0 ? (getNextSnapRatio(getSmallestSnapRatio()) ?? getLargestSnapRatio()) : 0.0

            panelView.snp_remakeConstraints { (make) in
                make.width.equalTo(sidePanelWidth)
                make.top.bottom.height.equalTo(view)
                mutableConstraint = make.left.equalTo(view.snp_right).offset(-currentPanelOffset).constraint
            }

            panInterceptView.snp_remakeConstraints { (make) in
                make.top.bottom.height.equalTo(panelView)
                make.left.equalTo(panelView).offset(-20)
                make.right.equalTo(panelView.snp_left).offset(15)
            }

            contentContainerView.snp_remakeConstraints { (make) in
                make.centerY.left.top.bottom.equalTo(view)
                if (!sidePanelCoversContent) {
                    make.right.equalTo(panelView.snp_left)
                } else {
                    make.right.equalTo(view)
                }
            }

            panelView.topDragLine.hidden = true
            panelView.bottomDragLine.hidden = true
            panelView.layer.cornerRadius = 0
        } else {
            currentPanelOffset = view.frame.height * currentPanelRatio

            contentContainerView.snp_remakeConstraints { (make) in
                make.edges.equalTo(view)
            }

            panelView.snp_remakeConstraints { (make) in
                make.width.equalTo(view).offset(-20)
                make.centerX.equalTo(view)
                mutableConstraint = make.top.equalTo(view.snp_bottom).offset(-currentPanelOffset).constraint
                make.bottom.equalTo(view).offset(cornerRadius)
            }

            panInterceptView.snp_remakeConstraints { (make) in
                make.width.equalTo(panelView)
                make.top.equalTo(panelView).offset(-30)
                make.bottom.equalTo(panelView.snp_top).offset(20)
                make.centerX.equalTo(panelView)
            }

            panelView.topDragLine.hidden = false
            panelView.bottomDragLine.hidden = false
            panelView.layer.cornerRadius = cornerRadius
        }

        floatingButton.snp_remakeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
            make.height.width.equalTo(50)
        }

        panelView.setupUI()
        view.layoutIfNeeded()
    }

    public func panelWasPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began, .Changed:
            if (sidePanel()) {
                let xLocation = recognizer.locationInView(view).x
                currentPanelOffset = min(sidePanelWidth, view.frame.width - xLocation)
            } else {
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

                currentPanelOffset = yOffset
            }
            view.layoutIfNeeded()
        case .Ended, .Cancelled, .Failed:
            if (sidePanel()) {
                let xLocation = recognizer.locationInView(view).x
                let xOffset = view.frame.width - xLocation

                var closestWidthSnapValue = xOffset > (sidePanelWidth / 2) ? sidePanelWidth : 0
                let xVelocity = recognizer.velocityInView(view).x
                if (xVelocity > velocityForSwipe) {
                    closestWidthSnapValue = 0
                } else if (xVelocity < -velocityForSwipe) {
                    closestWidthSnapValue = sidePanelWidth
                }

                movePanelToValue(closestWidthSnapValue, animated: true)
            } else {
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
                if (yVelocity > velocityForSwipe && currentSnapRatio > closestSnapRatio) {
                    if let nextRatio = getNextSnapRatio(closestSnapRatio!) {
                        closestSnapRatio = nextRatio
                    }
                } else if (yVelocity < -velocityForSwipe && currentSnapRatio < closestSnapRatio) {
                    if let prevRatio = getPreviousSnapRatio(closestSnapRatio!) {
                        closestSnapRatio = prevRatio
                    }
                }
                
                movePanelToSnapRatio(closestSnapRatio!, animated: true)
            }
        default:
            break
        }
    }

    public func panelWasTapped(recognizer: UIGestureRecognizer) {
        if (sidePanel() && sidePanelCoversContent) {
            movePanelToValue(0.0, animated: true)
        } else if (!sidePanel()) {
            movePanelToSnapRatio(snapHeights[0], animated: true)
        }
    }

    public func floatingButtonWasPressed(sender: WFAButton) {
        if (sidePanel()) {
            movePanelToValue(sidePanelWidth, animated: true)
        } else {
            // Move to 1st ratio above the smallest (which is typically 0.0), or the largest if there isn't one after the smallest
            movePanelToSnapRatio(getNextSnapRatio(getSmallestSnapRatio()) ?? getLargestSnapRatio(), animated: true)
        }
    }

    // Snap Height Helpers
    public func getNextSnapRatio(fromRatio: CGFloat) -> CGFloat? {
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

    public func getPreviousSnapRatio(fromRatio: CGFloat) -> CGFloat? {
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

    public func getSmallestSnapRatio() -> CGFloat {
        var smallestRatio: CGFloat = 1.0

        for ratio in snapHeights {
            if (ratio <= smallestRatio) {
                smallestRatio = ratio
            }
        }

        return smallestRatio
    }

    public func getLargestSnapRatio() -> CGFloat {
        var largestRatio: CGFloat = 0.0

        for ratio in snapHeights {
            if (ratio >= largestRatio) {
                largestRatio = ratio
            }
        }

        return largestRatio
    }

    public func movePanelToSnapRatio(ratio: CGFloat, animated: Bool = false) {
        // Get actual height
        let snapRatioOffset = view.frame.height * ratio
        currentPanelRatio = ratio

        movePanelToValue(snapRatioOffset, animated: animated)
    }

    public func movePanelToValue(value: CGFloat, animated: Bool = false) {
        // Need to layout any pending changes before animation
        view.layoutIfNeeded()

        currentPanelOffset = value
        // Set ratio as well for vertical panel in any case
        currentPanelRatio = currentPanelOffset > 0.0 ? (getNextSnapRatio(getSmallestSnapRatio()) ?? getLargestSnapRatio()) : 0.0

        if (animated) {
            if (sidePanel()) {
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            } else {
                UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            }
        } else {
            view.layoutIfNeeded()
        }

        floatingButton.hidden = value > 0.0
        panInterceptView.hidden = value <= 0.0
    }

    // Dictates if panel will slide from side, or bottom. This is calculated by modifying widthCapForSidePanel
    public func sidePanel() -> Bool {
        return view.frame.size.width > widthCapForSidePanel
    }
}

extension WPanelVC: WPanelDelegate {
    public func isSidePanel() -> Bool {
        return sidePanel()
    }

    public func setPanelRatio(ratio: CGFloat, animated: Bool) {
        movePanelToSnapRatio(ratio, animated: animated)
    }

    public func setPanelOffset(value: CGFloat, animated: Bool) {
        movePanelToValue(value, animated: animated)
    }
}

public class WPagingPanelVC: WPanelVC {
    // An array of the view controllers to be pages
    public var pages: [UIViewController]? {
        didSet {
            pagingVC.pages = pages
        }
    }
    // Height of the gray bar
    public var pagingControlHeight: CGFloat = 20 {
        didSet {
            pagingVC.pagingHeight = pagingControlHeight
        }
    }
    // When false, will only show paging bar when
    public var alwaysShowPagingBar = false {
        didSet {
            pagingVC.alwaysShowPagingBar = alwaysShowPagingBar
        }
    }

    // How close the paging bar will get to the top of the view before moving down
    public var pagingBarHidePadding: CGFloat = 20 {
        didSet {
            pagingVC.pagingBarHidePadding = pagingBarHidePadding
        }
    }

    public var canScrollWithOnlyOnePage = false {
        didSet {
            pagingVC.canScrollWithOnlyOnePage = canScrollWithOnlyOnePage
        }
    }

    public var pagingVC = WPanelPageControllerVC()

    public override func commonInit() {
        super.commonInit()

        addViewControllerToContainer(panelView.containerView, viewController: pagingVC)
    }
}

//
// View Controllers and helper classes to support paging within the WPanel
//

// View Controller to contain UIPageViewController and separate UIPageControl for customization options
public class WPanelPageControllerVC: UIViewController {
    public var pagingManager = WPanelPageManagerVC()
    public var pagingContainerView = UIView()

    public var pages: [UIViewController]? {
        didSet {
            pagingManager.pages = pages
            setupUI()
            calculateIfScrollingAllowed()
        }
    }

    public var pagingView = WPanelPagingView()
    public var pagingHeight: CGFloat = 20 {
        didSet {
            setupUI()
        }
    }

    public var alwaysShowPagingBar = false {
        didSet {
            setupUI()
        }
    }

    public var pagingBarHidePadding: CGFloat = 12 {
        didSet {
            setupUI()
        }
    }

    public var canScrollWithOnlyOnePage = false {
        didSet {
            calculateIfScrollingAllowed()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        setupUI()
    }

    public func commonInit() {
        view.addSubview(pagingView)
        view.addSubview(pagingContainerView)
        addViewControllerToContainer(pagingContainerView, viewController: pagingManager)

        pagingManager.pageIndicatorDelegate = self
    }

    public func setupUI() {
        if (alwaysShowPagingBar || pagingManager.pages?.count > 1) {
            pagingView.hidden = false

            pagingView.snp_remakeConstraints { (make) in
                make.width.centerX.equalTo(view)
                make.height.equalTo(pagingHeight)
                make.bottom.greaterThanOrEqualTo(view)
                make.top.equalTo(view).offset(pagingBarHidePadding).priorityMedium()
            }

            pagingContainerView.snp_remakeConstraints { (make) in
                make.width.centerX.top.equalTo(view)
                make.bottom.equalTo(pagingView.snp_top)
            }
        } else {
            pagingView.hidden = true

            pagingContainerView.snp_remakeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }

        view.layoutIfNeeded()
    }

    func setPageScrollEnabled(enabled: Bool = true) {
        if let scrollView = view.subviews.last?.subviews.first?.subviews.first as? UIScrollView {
            scrollView.scrollEnabled = enabled
        }
    }

    func calculateIfScrollingAllowed() {
        if (pages?.count > 1 || canScrollWithOnlyOnePage) {
            setPageScrollEnabled()
        } else {
            setPageScrollEnabled(false)
        }
    }

    public func changeToPageIndex(animated: Bool, index: Int) {
        if let pages = pages {
            if (index >= 0 && index < pages.count) {
                pagingManager.setViewControllers([pages[index]], direction: .Forward, animated: animated, completion: nil)
                wPanelPageManager(pagingManager, didUpdatePageIndex: index)
            }
        }
    }
}

extension WPanelPageControllerVC: WPanelPageManagerDelegate {
    func wPanelPageManager(pageManager: WPanelPageManagerVC, didUpdatePageCount count: Int) {
        pagingView.pagingControl.numberOfPages = count
    }

    func wPanelPageManager(pageManager: WPanelPageManagerVC, didUpdatePageIndex index: Int) {
        pagingView.pagingControl.currentPage = index
    }
}

public class WPanelPageManagerVC: UIPageViewController {
    var pages: [UIViewController]? {
        didSet {
            setupUI()
        }
    }

    weak var pageIndicatorDelegate: WPanelPageManagerDelegate?

    public override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: options)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        setupUI()
    }

    public func setupUI() {
        if let pages = pages, firstPage = pages.first {
            setViewControllers([firstPage], direction: .Forward, animated: true, completion: nil)

            pageIndicatorDelegate?.wPanelPageManager(self, didUpdatePageCount: pages.count)
        }
    }
}

extension WPanelPageManagerVC: UIPageViewControllerDelegate {
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = pages?.indexOf(firstViewController) {

            pageIndicatorDelegate?.wPanelPageManager(self, didUpdatePageIndex: index)
        }
    }
}

extension WPanelPageManagerVC: UIPageViewControllerDataSource {
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let pages = pages {
            guard let viewControllerIndex = pages.indexOf(viewController) else {
                return nil
            }

            let previousIndex = viewControllerIndex - 1

            guard previousIndex >= 0 else {
                return nil
            }

            guard pages.count > previousIndex else {
                return nil
            }
            
            return pages[previousIndex]
        }

        return nil
    }

    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let pages = pages {
            guard let viewControllerIndex = pages.indexOf(viewController) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1

            guard pages.count != nextIndex else {
                return nil
            }
            
            return pages[nextIndex]
        }

        return nil
    }
}

public class WPanelPagingView: UIView {
    public var pagingControl = UIPageControl() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(pagingControl)
            setupUI()
        }
    }

    public var currentPageIndicatorTintColor: UIColor = UIColor.purpleColor() {
        didSet {
            pagingControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    public var pageIndicatorTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            pagingControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRectZero)
    }

    public func commonInit() {
        addSubview(pagingControl)

        backgroundColor = .grayColor()

        setupUI()
    }

    public func setupUI() {
        pagingControl.snp_remakeConstraints { (make) in
            make.centerX.width.equalTo(self)
            make.height.equalTo(0)
            make.centerY.equalTo(self).offset(-2)
        }

        pagingControl.pageIndicatorTintColor = pageIndicatorTintColor
        pagingControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }
}
