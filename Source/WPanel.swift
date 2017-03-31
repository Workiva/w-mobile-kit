//
//  WPanel.swift
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

open class WPanel: UIView {
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
        self.init(frame: CGRect.zero)
    }

    public func commonInit() {
        backgroundColor = .clear
        containerView.backgroundColor = .white

        addSubview(containerView)
        addSubview(topDragLine)
        addSubview(bottomDragLine)

        topDragLine.backgroundColor = .gray
        bottomDragLine.backgroundColor = .gray

        clipsToBounds = true

        setupUI()
    }

    open func setupUI() {
        let cornerRadius = layer.cornerRadius
        containerView.snp.remakeConstraints { (make) in
            make.left.right.width.top.equalTo(self)
            make.bottom.equalTo(self).offset(-cornerRadius)
        }

        topDragLine.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(6)
            make.width.equalTo(dragLineWidth)
            make.centerX.equalTo(self)
            make.height.equalTo(1)
        }

        bottomDragLine.snp.remakeConstraints { (make) in
            make.top.equalTo(topDragLine.snp.bottom).offset(4)
            make.height.equalTo(topDragLine)
            make.centerX.equalTo(topDragLine)
            make.width.equalTo(topDragLine)
        }

        layoutIfNeeded()
    }
}

open class WPanelVC: WSideMenuContentVC {
    public var panelView = WPanel()
    public var floatingButton = WFAButton()
    public var panInterceptView = UIView()
    public var contentContainerView = UIView()

    // Will either be side or top constraint to move the panel
    var mutableConstraint: Constraint?

    // Controls the constraint for the movement of the panel
    public var currentPanelOffset: CGFloat = 0 {
        didSet {            
            mutableConstraint?.update(offset: -currentPanelOffset)
        }
    }

    var currentPanelRatio: CGFloat = 0

    // Dictates if panel will slide from side, or bottom. This is calculated by modifying widthCapForSidePanel
    public var sidePanel: Bool {
        return view.frame.size.width > widthCapForSidePanel
    }

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

    // Minimum height to snap to in case the screen height is too small for content you want to present
    public var minimumSnapHeight: CGFloat?

    // Cap value on how far user can drag the panel up before it snaps back to heighest value in snapHeights
    // 0.0 means no "rubber band" effect, 1.0 means they can drag as far as they want until it snaps back
    public var springValuePastMaxHeight: CGFloat = 0.02

    // Can set border/outline properties on the panel from the view controller for convenience
    public var outlineWidth: CGFloat = 0.5 {
        didSet {
            panelView.layer.borderWidth = outlineWidth
        }
    }
    public var outlineColor: CGColor = UIColor.lightGray.cgColor {
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

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        currentPanelRatio = getSmallestSnapRatio()
        currentPanelOffset = view.frame.height * currentPanelRatio
        panInterceptView.isHidden = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupUI()
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(
            alongsideTransition: { (context) in
                self.setupUI()
            },
            completion: nil
        )
    }

    open func commonInit() {
        floatingButton.addTarget(self, action: #selector(WPanelVC.floatingButtonWasPressed(sender:)), for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(recognizer:)))
        tapRecognizer.cancelsTouchesInView = false
        panInterceptView.addGestureRecognizer(tapRecognizer)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasPanned(recognizer:)))
        panRecognizer.cancelsTouchesInView = false
        panInterceptView.addGestureRecognizer(panRecognizer)

        let tapHideRecognizer = UITapGestureRecognizer(target: self, action: #selector(WPanelVC.panelWasTapped(recognizer:)))
        tapHideRecognizer.cancelsTouchesInView = false
        contentContainerView.addGestureRecognizer(tapHideRecognizer)
    }

    open func setupUI() {
        view.addSubview(contentContainerView)
        view.addSubview(floatingButton)
        view.addSubview(panelView)
        view.addSubview(panInterceptView)

        panelView.layer.borderWidth = outlineWidth
        panelView.layer.borderColor = outlineColor

        panelView.snp.removeConstraints()

        sidePanelCoversContent = view.frame.width <= sidePanelCoversContentUpToWidth

        if (sidePanel) {
            currentPanelOffset = currentPanelOffset > 0.0 ? sidePanelWidth : 0.0
            currentPanelRatio = currentPanelOffset > 0.0 ? (getNextSnapRatio(fromRatio: getSmallestSnapRatio()) ?? getLargestSnapRatio()) : 0.0

            panelView.snp.remakeConstraints { (make) in
                make.width.equalTo(sidePanelWidth)
                make.top.bottom.height.equalTo(view)
                mutableConstraint = make.left.equalTo(view.snp.right).offset(-currentPanelOffset).constraint
            }

            panInterceptView.snp.remakeConstraints { (make) in
                make.top.bottom.height.equalTo(panelView)
                make.left.equalTo(panelView).offset(-20)
                make.right.equalTo(panelView.snp.left).offset(15)
            }

            contentContainerView.snp.remakeConstraints { (make) in
                make.centerY.left.top.bottom.equalTo(view)
                if (!sidePanelCoversContent) {
                    make.right.equalTo(panelView.snp.left)
                } else {
                    make.right.equalTo(view)
                }
            }

            panelView.topDragLine.isHidden = true
            panelView.bottomDragLine.isHidden = true
            panelView.layer.cornerRadius = 0
        } else {
            var offset = view.frame.height * currentPanelRatio
            if let minimumSnapHeight = minimumSnapHeight, offset < minimumSnapHeight && offset > 0.0 {
                offset = minimumSnapHeight
            }

            currentPanelOffset = offset

            contentContainerView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view)
            }

            panelView.snp.remakeConstraints { (make) in
                make.width.equalTo(view).offset(-20)
                make.centerX.equalTo(view)
                mutableConstraint = make.top.equalTo(view.snp.bottom).offset(-currentPanelOffset).constraint
                make.bottom.equalTo(view).offset(cornerRadius)
            }

            panInterceptView.snp.remakeConstraints { (make) in
                make.width.equalTo(panelView)
                make.top.equalTo(panelView).offset(-30)
                make.bottom.equalTo(panelView.snp.top).offset(20)
                make.centerX.equalTo(panelView)
            }

            panelView.topDragLine.isHidden = false
            panelView.bottomDragLine.isHidden = false
            panelView.layer.cornerRadius = cornerRadius
        }

        floatingButton.snp.remakeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
            make.height.width.equalTo(50)
        }

        panelView.setupUI()
        view.layoutIfNeeded()
    }

    open func panelWasPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            if (sidePanel) {
                let xLocation = recognizer.location(in: view).x
                currentPanelOffset = min(sidePanelWidth, view.frame.width - xLocation)
            } else {
                let yLocation = recognizer.location(in: view).y
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
        case .ended, .cancelled, .failed:
            if (sidePanel) {
                let xLocation = recognizer.location(in: view).x
                let xOffset = view.frame.width - xLocation

                var closestWidthSnapValue = xOffset > (sidePanelWidth / 2) ? sidePanelWidth : 0
                let xVelocity = recognizer.velocity(in: view).x
                if (xVelocity > velocityForSwipe) {
                    closestWidthSnapValue = 0
                } else if (xVelocity < -velocityForSwipe) {
                    closestWidthSnapValue = sidePanelWidth
                }

                movePanelToValue(value: closestWidthSnapValue, animated: true)
            } else {
                let yLocation = recognizer.location(in: view).y
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
                let yVelocity = -recognizer.velocity(in: view).y
                if (yVelocity > velocityForSwipe && currentSnapRatio > closestSnapRatio!) {
                    if let nextRatio = getNextSnapRatio(fromRatio: closestSnapRatio!) {
                        closestSnapRatio = nextRatio
                    }
                } else if (yVelocity < -velocityForSwipe && currentSnapRatio < closestSnapRatio!) {
                    if let prevRatio = getPreviousSnapRatio(fromRatio: closestSnapRatio!) {
                        closestSnapRatio = prevRatio
                    }
                }

                // Verify the height is not smaller than the minimum height if set
                let actualHeight = view.frame.height * closestSnapRatio!
                if let minimumSnapHeight = minimumSnapHeight, closestSnapRatio! > 0.0 && actualHeight < minimumSnapHeight {
                    movePanelToValue(value: minimumSnapHeight, animated: true)
                } else {
                    movePanelToSnapRatio(ratio: closestSnapRatio!, animated: true)
                }
            }
        default:
            break
        }
    }

    open func panelWasTapped(recognizer: UIGestureRecognizer) {
        if (sidePanel && sidePanelCoversContent) {
            movePanelToValue(value: 0.0, animated: true)
        } else if (!sidePanel) {
            movePanelToSnapRatio(ratio: snapHeights[0], animated: true)
        }
    }

    open func floatingButtonWasPressed(sender: WFAButton) {
        if (sidePanel) {
            movePanelToValue(value: sidePanelWidth, animated: true)
        } else {
            // Move to 1st ratio above the smallest (which is typically 0.0), or the largest if there isn't one after the smallest
            let snapRatio = getNextSnapRatio(fromRatio: getSmallestSnapRatio()) ?? getLargestSnapRatio()

            // Verify the height is not smaller than the minimum height if set
            let actualHeight = view.frame.height * snapRatio
            if let minimumSnapHeight = minimumSnapHeight, actualHeight < minimumSnapHeight {
                movePanelToValue(value: minimumSnapHeight, animated: true)
            } else {
                movePanelToSnapRatio(ratio: snapRatio, animated: true)
            }
        }
    }

    // Snap Height Helpers
    open func getNextSnapRatio(fromRatio: CGFloat) -> CGFloat? {
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

    open func getPreviousSnapRatio(fromRatio: CGFloat) -> CGFloat? {
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

    open func getSmallestSnapRatio() -> CGFloat {
        var smallestRatio: CGFloat = 1.0

        for ratio in snapHeights {
            if (ratio <= smallestRatio) {
                smallestRatio = ratio
            }
        }

        return smallestRatio
    }

    open func getLargestSnapRatio() -> CGFloat {
        var largestRatio: CGFloat = 0.0

        for ratio in snapHeights {
            if (ratio >= largestRatio) {
                largestRatio = ratio
            }
        }

        return largestRatio
    }

    open func movePanelToSnapRatio(ratio: CGFloat, animated: Bool = false) {
        // Get actual height
        let snapRatioOffset = view.frame.height * ratio
        currentPanelRatio = ratio

        movePanelToValue(value: snapRatioOffset, animated: animated)
    }

    open func movePanelToValue(value: CGFloat, animated: Bool = false) {
        // Need to layout any pending changes before animation
        view.layoutIfNeeded()

        currentPanelOffset = value

        // Set ratio as well for vertical panel in any case
        if (sidePanel) {
            currentPanelRatio = currentPanelOffset > 0.0 ? (getNextSnapRatio(fromRatio: getSmallestSnapRatio()) ?? getLargestSnapRatio()) : 0.0
        } else {
            currentPanelRatio = currentPanelOffset / view.frame.height
        }

        if (animated) {
            if (sidePanel) {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            }
        } else {
            view.layoutIfNeeded()
        }

        floatingButton.isHidden = value > 0.0
        panInterceptView.isHidden = value <= 0.0
    }
}

extension WPanelVC: WPanelDelegate {
    public func isSidePanel() -> Bool {
        return sidePanel
    }

    public func setPanelRatio(ratio: CGFloat, animated: Bool) {
        movePanelToSnapRatio(ratio: ratio, animated: animated)
    }

    public func setPanelOffset(value: CGFloat, animated: Bool) {
        movePanelToValue(value: value, animated: animated)
    }
}

open class WPagingPanelVC: WPanelVC {
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

    open override func commonInit() {
        super.commonInit()

        addViewControllerToContainer(panelView.containerView, viewController: pagingVC)
    }
}

//
// View Controllers and helper classes to support paging within the WPanel
//

// View Controller to contain UIPageViewController and separate UIPageControl for customization options
open class WPanelPageControllerVC: UIViewController {
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

    open override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        setupUI()
    }

    open func commonInit() {
        view.addSubview(pagingView)
        view.addSubview(pagingContainerView)
        addViewControllerToContainer(pagingContainerView, viewController: pagingManager)

        pagingManager.pageIndicatorDelegate = self
    }

    open func setupUI() {
        guard let pages = pagingManager.pages else {
            return
        }

        if (alwaysShowPagingBar || pages.count > 1) {
            pagingView.isHidden = false

            pagingView.snp.remakeConstraints { (make) in
                make.width.centerX.equalTo(view)
                make.height.equalTo(pagingHeight)
                make.bottom.greaterThanOrEqualTo(view)
                make.top.equalTo(view).offset(pagingBarHidePadding).priority(500)
            }

            pagingContainerView.snp.remakeConstraints { (make) in
                make.width.centerX.top.equalTo(view)
                make.bottom.equalTo(pagingView.snp.top)
            }
        } else {
            pagingView.isHidden = true

            pagingContainerView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }

        view.layoutIfNeeded()
    }

    func setPageScrollEnabled(enabled: Bool = true) {
        if let scrollView = view.subviews.last?.subviews.first?.subviews.first as? UIScrollView {
            scrollView.isScrollEnabled = enabled
        }
    }

    func calculateIfScrollingAllowed() {
        if ((pages?.count)! > 1 || canScrollWithOnlyOnePage) {
            setPageScrollEnabled()
        } else {
            setPageScrollEnabled(enabled: false)
        }
    }

    open func changeToPageIndex(animated: Bool, index: Int) {
        if let pages = pages {
            if (index >= 0 && index < pages.count) {
                pagingManager.setViewControllers([pages[index]], direction: .forward, animated: animated, completion: nil)
                wPanelPageManager(pageManager: pagingManager, didUpdatePageIndex: index)
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

open class WPanelPageManagerVC: UIPageViewController {
    var pages: [UIViewController]? {
        didSet {
            setupUI()
        }
    }

    weak var pageIndicatorDelegate: WPanelPageManagerDelegate?

    public override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        setupUI()
    }

    open func setupUI() {
        if let pages = pages, let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)

            pageIndicatorDelegate?.wPanelPageManager(pageManager: self, didUpdatePageCount: pages.count)
        }
    }
}

extension WPanelPageManagerVC: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = pages?.index(of: firstViewController) {

            pageIndicatorDelegate?.wPanelPageManager(pageManager: self, didUpdatePageIndex: index)
        }
    }
}

extension WPanelPageManagerVC: UIPageViewControllerDataSource {
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pages = pages {
            guard let viewControllerIndex = pages.index(of: viewController) else {
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

    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pages = pages {
            guard let viewControllerIndex = pages.index(of: viewController) else {
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

open class WPanelPagingView: UIView {
    public var pagingControl = UIPageControl() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(pagingControl)
            setupUI()
        }
    }

    public var currentPageIndicatorTintColor: UIColor = UIColor.purple {
        didSet {
            pagingControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    public var pageIndicatorTintColor: UIColor = UIColor.white {
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
        self.init(frame: CGRect.zero)
    }

    open func commonInit() {
        addSubview(pagingControl)

        backgroundColor = .gray

        setupUI()
    }

    open func setupUI() {
        pagingControl.snp.remakeConstraints { (make) in
            make.centerX.width.equalTo(self)
            make.height.equalTo(0)
            make.centerY.equalTo(self).offset(-2)
        }

        pagingControl.pageIndicatorTintColor = pageIndicatorTintColor
        pagingControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }
}
