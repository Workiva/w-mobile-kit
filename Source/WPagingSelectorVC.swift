//
//  WPagingSelectorControl.swift
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

let DEFAULT_TAB_WIDTH: CGFloat = 90.0
let MIN_TAB_WIDTH: CGFloat = 20.0
let ANIMATION_DURATION = 0.2
let SELECTION_INDICATOR_VIEW_HEIGHT: CGFloat = 3.0
public let DEFAULT_PAGING_SELECTOR_HEIGHT: CGFloat = 44.0
public let DEFAULT_PAGING_SELECTOR_SIDE_PADDING: CGFloat = 0.0

public enum WPagingWidthMode {
    case Static, Dynamic
}

@objc protocol WPagingSelectorControlDelegate: class {
    optional func willChangeToTab(sender: WPagingSelectorControl, tab: Int)
    optional func didChangeToTab(sender: WPagingSelectorControl, tab: Int)
}

public protocol WPagingSelectorVCDelegate: class {
    func shouldShowShadow(sender: WPagingSelectorVC) -> Bool
}

public class WScrollView: UIScrollView {
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!dragging) {
            nextResponder()?.touchesBegan(touches, withEvent: event)
        } else {
            super.touchesBegan(touches, withEvent: event)
        }
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!dragging) {
            nextResponder()?.touchesMoved(touches, withEvent: event)
        } else {
            super.touchesMoved(touches, withEvent: event)
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!dragging) {
            nextResponder()?.touchesEnded(touches, withEvent: event)
        } else {
            super.touchesEnded(touches, withEvent: event)
        }
    }
}

public class WSelectionIndicatorView: UIView {
    public init(alpha: CGFloat) {
        super.init(frame: CGRectZero)

        self.alpha = alpha
    }

    override convenience init(frame: CGRect) {
        self.init(alpha: 0.7)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func moveToSelection(selectionView: UIView, numberOfSections: NSInteger, contentView: UIView) {
        snp_remakeConstraints { (make) in
            make.left.equalTo(selectionView).offset(6)
            make.width.equalTo(selectionView).offset(-12)
            make.height.equalTo(SELECTION_INDICATOR_VIEW_HEIGHT)
            make.bottom.equalTo(contentView)
        }
    }
}

public class WTabView: UIView {
    private var title = String()
    private var label = UILabel()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(title text: String) {
        super.init(frame: CGRectZero)

        title = text
        label.text = title
        label.textAlignment = NSTextAlignment.Center

        addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.top.equalTo(self)
        }

        label.font = UIFont.systemFontOfSize(label.font.pointSize)
    }
}

public class WPagingSelectorControl: UIControl {
    // Accessible properties
    public var tabTextColor: UIColor = .grayColor() {
        didSet {
            for i in 0..<tabViews.count {
                let tab: WTabView = tabViews[i]
                tab.label.textColor = tabTextColor
            }
        }
    }
    
    public var separatorLineColor: UIColor = WThemeManager.sharedInstance.currentTheme.pagingSelectorSeparatorColor {
        didSet {
            separatorLine.backgroundColor = separatorLineColor
        }
    }
    
    public var separatorLineHeight: CGFloat = 1.0 {
        didSet {
            separatorLine.snp_updateConstraints { (make) in
                make.height.equalTo(separatorLineHeight)
            }
            
            layoutIfNeeded()
        }
    }

    public private(set) var widthMode: WPagingWidthMode = .Dynamic
    public private(set) var tabWidth: CGFloat?
    public private(set) var tabSpacing: CGFloat = 0.0
    public private(set) var selectedPage: Int?

    private var scrollView = WScrollView()
    private var pages = [WPage]()
    private var contentView = UIView()
    private var tabContainerView = UIView()
    private var separatorLine = UIView()
    private var selectionIndicatorView = WSelectionIndicatorView()
    private var selectedContainer: WTabView?
    private var tabViews = Array<WTabView>()
    private var isAnimating = false
    private weak var delegate: WPagingSelectorControlDelegate?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public convenience init(titles: Array<String>) {
        self.init(titles: titles, tabWidth: nil)
    }

    public init(titles: Array<String>, tabWidth: CGFloat?, tabSpacing: CGFloat = 0.0) {
        super.init(frame: CGRectZero)

        for title in titles {
            let page = WPage(title: title, viewController: nil)
            pages.append(page)
        }

        if tabSpacing > 0.0 {
            self.tabSpacing = tabSpacing
        }

        if let tabWidth = tabWidth {
            widthMode = .Static

            if (tabWidth >= MIN_TAB_WIDTH) {
                self.tabWidth = tabWidth
            } else {
                print("Invalid width: ", tabWidth, ". Defaulting to min tab width: ", MIN_TAB_WIDTH)
            }
        } else {
            widthMode = .Dynamic
        }

        commonInit()
    }

    public convenience init(pages: Array<WPage>) {
        self.init(pages: pages, tabWidth: nil)
    }

    public init(pages: Array<WPage>, tabWidth: CGFloat?, tabSpacing: CGFloat = 0.0) {
        super.init(frame: CGRectZero)

        self.pages = pages

        if tabSpacing > 0.0 {
            self.tabSpacing = tabSpacing
        }

        if let tabWidth = tabWidth {
            widthMode = .Static

            if (tabWidth >= MIN_TAB_WIDTH) {
                self.tabWidth = tabWidth
            } else {
                print("Invalid width: ", tabWidth, ". Defaulting to min tab width: ", MIN_TAB_WIDTH)
            }
        } else {
            widthMode = .Dynamic
        }

        commonInit()
    }

    public func commonInit() {
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollEnabled = true

        addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        
        addSubview(separatorLine)
        separatorLine.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(separatorLineHeight)
        }

        var contentWidth: CGFloat = 0.0
        if (widthMode == .Static) {
            if pages.count > 1 {
                contentWidth = (tabWidth! * CGFloat(pages.count)) + (tabSpacing * (CGFloat(pages.count) - 1))
            } else {
                contentWidth = tabWidth! * CGFloat(pages.count)
            }
        }

        scrollView.addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)

            if (widthMode == .Dynamic) {
                make.width.equalTo(scrollView)
            } else if (contentWidth > UIScreen.mainScreen().bounds.width) {
                make.width.equalTo(contentWidth)
            } else {
                make.width.equalTo(scrollView)
            }
        }

        contentView.addSubview(tabContainerView)
        tabContainerView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)

            if (widthMode == .Dynamic) {
                make.left.equalTo(contentView)
                make.width.equalTo(contentView)
            } else {
                make.width.equalTo(contentWidth)
                // TODO: Temporary solution. Will not work if the scroll view is not the size of the screen
                // Using the center works for non-scrollable number of tabs
                // Using left works for scrolling tabs
                if (contentWidth > UIScreen.mainScreen().bounds.width) {
                    make.left.equalTo(scrollView)
                } else {
                    make.centerX.equalTo(contentView.snp_centerX)
                }
            }
        }

        contentView.addSubview(selectionIndicatorView)

        opaque = false

        if (pages.count > 0) {
            for i in 0..<pages.count {
                let tab = WTabView(title: pages[i].title)
                tab.label.textColor = tabTextColor

                tab.tag = i
                tab.userInteractionEnabled = true

                tabContainerView.addSubview(tab)

                tabViews.append(tab)

                tab.snp_makeConstraints { (make) in
                    if i == 0 {
                        make.left.equalTo(tabContainerView)
                    } else {
                        make.left.equalTo(tabViews[i - 1].snp_right).offset(tabSpacing)
                    }

                    if widthMode == .Dynamic {
                        make.width.equalTo(tabContainerView).dividedBy(pages.count)
                    } else {
                        make.width.equalTo(tabWidth!)
                    }

                    make.height.equalTo(tabContainerView)
                    make.top.equalTo(tabContainerView)
                }

                let recognizer = UITapGestureRecognizer(target: self, action: #selector(WPagingSelectorControl.tappedTabItem(_:)))
                tab.addGestureRecognizer(recognizer)

                if i == 0 {
                    selectedContainer = tab
                }
            }

            layoutIfNeeded()

            moveToTabIndex(0)
        }

        if (widthMode == .Dynamic) {
            scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: contentView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: contentWidth, height: contentView.frame.size.height)
        }
    }

    @objc private func tappedTabItem(recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        if (index == selectedContainer!.tag || isAnimating) {
            return
        }
        moveToTabIndex(index)
    }

    public func moveToTabIndex(tabIndex: NSInteger) {
        selectedPage = tabIndex

        let newSelectedContainer = tabViews[tabIndex]
        selectedContainer?.label.font = UIFont.systemFontOfSize(selectedContainer!.label.font.pointSize)
        newSelectedContainer.label.font = UIFont.boldSystemFontOfSize(newSelectedContainer.label.font.pointSize)

        selectedContainer = newSelectedContainer
        scrollView.scrollRectToVisible(selectedContainer!.frame, animated: true)
        selectionIndicatorView.moveToSelection(selectedContainer!, numberOfSections: pages.count, contentView: contentView)

        delegate?.willChangeToTab?(self, tab: tabIndex)

        isAnimating = true
        UIView.animateWithDuration(ANIMATION_DURATION,
            animations: {
                self.layoutIfNeeded()
            },
            completion: { finished in
                self.delegate?.didChangeToTab?(self, tab: tabIndex)
                self.isAnimating = false
            }
        )
    }
}

public struct WPage {
    public var title: String = ""
    public var viewController: WSideMenuContentVC?

    public init(title: String) {
        self.init(title: title, viewController: nil)
    }

    public init(title: String, viewController: WSideMenuContentVC?) {
        self.title = title
        self.viewController = viewController
    }
}

public class WPagingSelectorVC: WSideMenuContentVC, WPagingSelectorControlDelegate {
    public private(set) var pagingSelectorControl: WPagingSelectorControl?
    public var pagingControlHeight: CGFloat = DEFAULT_PAGING_SELECTOR_HEIGHT {
        didSet {
            pagingControlConstraintsChanged()
        }
    }

    public var pagingControlSidePadding: CGFloat = DEFAULT_PAGING_SELECTOR_SIDE_PADDING {
        didSet {
            pagingControlConstraintsChanged()
        }
    }

    public var tabTextColor: UIColor = .blackColor() {
        didSet {
            pagingSelectorControl?.tabTextColor = tabTextColor
        }
    }
    
    public var separatorLineColor: UIColor = WThemeManager.sharedInstance.currentTheme.pagingSelectorSeparatorColor {
        didSet {
            pagingSelectorControl?.separatorLineColor = separatorLineColor
        }
    }
    
    public var separatorLineHeight: CGFloat = 1.0 {
        didSet {
            pagingSelectorControl?.separatorLineHeight = separatorLineHeight
        }
    }
    
    public var shadowColor: CGColor = UIColor.blackColor().CGColor
    public var shadowRadius: CGFloat = 4
    public var shadowOpacity: Float = 0.3
    public var shadowAnimationDuration = 0.2
    public private(set) var mainContainerView = UIView()

    var mainViewController: UIViewController?    
    var currentPageIndex = 0
    var pageToSet: Int?
    var isShowingShadow = false
    
    public weak var delegate: WPagingSelectorVCDelegate?

    public var pages:[WPage] = [WPage]() {
        didSet {
            setupUI()
        }
    }

    public var tabWidth: CGFloat? {
        didSet {
            pagingControlConstraintsChanged()
        }
    }

    public var tabSpacing: CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainContainerView)

        mainContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view)
        }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let page = pageToSet {
            setPage(page)
        }
    }

    public func setupUI() {
        if let pagingSelector = pagingSelectorControl {
            pagingSelector.removeFromSuperview()
            pagingSelectorControl = nil
        }

        if (tabWidth == nil || tabWidth >= MIN_TAB_WIDTH) {
            pagingSelectorControl = WPagingSelectorControl(pages: pages, tabWidth: tabWidth, tabSpacing: tabSpacing)
        } else {
            pagingSelectorControl = WPagingSelectorControl(pages: pages, tabWidth: DEFAULT_TAB_WIDTH, tabSpacing: tabSpacing)
        }

        pagingSelectorControl?.delegate = self

        if let pagingSelectorControl = pagingSelectorControl {
            pagingSelectorControl.tabTextColor = tabTextColor
            pagingSelectorControl.separatorLineColor = separatorLineColor

            view.addSubview(pagingSelectorControl)
            pagingSelectorControl.snp_makeConstraints { (make) in
                make.left.equalTo(view).offset(pagingControlSidePadding)
                make.right.equalTo(view).offset(-pagingControlSidePadding)
                make.height.equalTo(pagingControlHeight)
                make.top.equalTo(view)
            }

            mainContainerView.snp_remakeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.bottom.equalTo(view)
                make.top.equalTo(pagingSelectorControl.snp_bottom)
            }
        }

        if (pages.count > 0) {
            let newMainViewController = pages[0].viewController
            addViewControllerToContainer(mainContainerView, viewController: newMainViewController)

            self.mainViewController = newMainViewController
        }
    }

    public func pagingControlConstraintsChanged() {
        setupUI()
    }

    // Delegate methods
    func willChangeToTab(sender: WPagingSelectorControl, tab: Int) {
        // Store old main view controller to remove after animation
        let oldMainViewController = mainViewController
        currentPageIndex = tab

        if let newMainViewController = pages[tab].viewController {
            mainViewController = newMainViewController
            
            if let mainViewController = mainViewController as? WPagingSelectorVCDelegate {
                delegate = mainViewController
            } else {
                delegate = nil
            }
                        
            addViewControllerToContainer(mainContainerView, viewController: mainViewController)

            // Animates view controller in left or right
            mainViewController?.view.snp_remakeConstraints(closure: { (make) in
                if (tab < currentPageIndex) {
                    make.right.equalTo(mainContainerView.snp_left)
                } else {
                    make.left.equalTo(mainContainerView.snp_right)
                }
                make.top.equalTo(mainContainerView)
                make.bottom.equalTo(mainContainerView)
                make.width.equalTo(mainContainerView)
            })

            mainContainerView.layoutIfNeeded()

            mainViewController?.view.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(mainContainerView)
                make.top.equalTo(mainContainerView)
                make.bottom.equalTo(mainContainerView)
                make.right.equalTo(mainContainerView)
            })

            if oldMainViewController != nil {
                oldMainViewController?.view.snp_remakeConstraints(closure: { (make) in
                    if (tab > currentPageIndex) {
                        make.right.equalTo(mainContainerView.snp_left)
                    } else {
                        make.left.equalTo(mainContainerView.snp_right)
                    }
                    make.top.equalTo(mainContainerView)
                    make.bottom.equalTo(mainContainerView)
                    make.width.equalTo(mainContainerView)
                })
            }
            
            UIView.animateWithDuration(ANIMATION_DURATION,
                animations: {
                    self.mainContainerView.layoutIfNeeded()
                },
                completion: { (finished) in
                    if let oldMainViewController = oldMainViewController {
                        self.removeViewControllerFromContainer(oldMainViewController)
                    }
            })
            
            if let delegate = delegate {
                setShadow(delegate.shouldShowShadow(self), animated: true)
            } else {
                setShadow(false, animated: true)
            }
        }
    }

    public func setPage(index: Int) {
        if (view.window == nil) {
            pageToSet = index
        } else if (index != currentPageIndex) {
            pagingSelectorControl?.moveToTabIndex(index)
            pageToSet = nil
        }
    }
    
    public func setShadow(enabled: Bool, animated: Bool = false) {
        pagingSelectorControl?.layer.shadowOffset = CGSize(width: 0, height: 0)
        pagingSelectorControl?.layer.shadowRadius = shadowRadius
        pagingSelectorControl?.layer.shadowColor = shadowColor
        
        if (enabled != isShowingShadow) {
            isShowingShadow = enabled
            
            if (animated) {
                let animation = CABasicAnimation(keyPath: "shadowOpacity")
                animation.fromValue = enabled ? 0.0 : shadowOpacity
                animation.toValue = enabled ? shadowOpacity : 0.0
                animation.duration = shadowAnimationDuration
                animation.fillMode = kCAFillModeForwards
                animation.removedOnCompletion = false
                
                self.pagingSelectorControl?.layer.addAnimation(animation, forKey: "shadowAnimation")
            } else {
                pagingSelectorControl?.layer.shadowOpacity = enabled ? shadowOpacity : 0.0
            }
        }
    }
}

extension WPagingSelectorVC : UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let delegate = delegate {
            setShadow(delegate.shouldShowShadow(self), animated: true)
        } else {
            if (scrollView.contentOffset.y <= 0) {
                setShadow(false, animated: true)
            } else {
                setShadow(true, animated: true)
            }
        }
    }
}
