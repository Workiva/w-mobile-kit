//
//  WPagingSelectorControl.swift
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

let DEFAULT_TAB_WIDTH: CGFloat = 90.0
let MIN_TAB_WIDTH: CGFloat = 20.0
let ANIMATION_DURATION = 0.2
let SELECTION_INDICATOR_VIEW_HEIGHT: CGFloat = 3.0
public let DEFAULT_PAGING_SELECTOR_HEIGHT: CGFloat = 44.0
public let DEFAULT_PAGING_SELECTOR_SIDE_PADDING: CGFloat = 0.0

public enum WPagingWidthMode {
    case `static`, dynamic
}

@objc protocol WPagingSelectorControlDelegate: class {
    @objc optional func willChangeToTab(_ sender: WPagingSelectorControl, tab: Int)
    @objc optional func didChangeToTab(_ sender: WPagingSelectorControl, tab: Int)
}

public protocol WPagingSelectorVCDelegate: class {
    func shouldShowShadow(_ sender: WPagingSelectorVC) -> Bool
}

open class WScrollView: UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isDragging) {
            next?.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isDragging) {
            next?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isDragging) {
            next?.touchesEnded(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
}

open class WSelectionIndicatorView: UIView {
    public init(alpha: CGFloat) {
        super.init(frame: CGRect.zero)

        self.alpha = alpha
    }

    override convenience init(frame: CGRect) {
        self.init(alpha: 0.7)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func moveToSelection(_ selectionView: UIView, numberOfSections: NSInteger, contentView: UIView) {
        snp.remakeConstraints { (make) in
            make.left.equalTo(selectionView).offset(6)
            make.width.equalTo(selectionView).offset(-12)
            make.height.equalTo(SELECTION_INDICATOR_VIEW_HEIGHT)
            make.bottom.equalTo(contentView)
        }
    }
}

open class WTabView: UIView {
    fileprivate var title = String()
    fileprivate var label = UILabel()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(title text: String) {
        super.init(frame: CGRect.zero)

        title = text
        label.text = title
        label.textAlignment = NSTextAlignment.center

        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.top.equalTo(self)
        }

        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
    }
}

open class WPagingSelectorControl: UIControl {
    // Accessible properties
    open var tabTextColor: UIColor = .gray {
        didSet {
            for i in 0..<tabViews.count {
                let tab: WTabView = tabViews[i]
                tab.label.textColor = tabTextColor
            }
        }
    }
    
    open var separatorLineColor: UIColor = WThemeManager.sharedInstance.currentTheme.pagingSelectorSeparatorColor {
        didSet {
            separatorLine.backgroundColor = separatorLineColor
        }
    }
    
    open var separatorLineHeight: CGFloat = 1.0 {
        didSet {
            separatorLine.snp.updateConstraints { (make) in
                make.height.equalTo(separatorLineHeight)
            }
            
            layoutIfNeeded()
        }
    }

    open fileprivate(set) var widthMode: WPagingWidthMode = .dynamic
    open fileprivate(set) var tabWidth: CGFloat?
    open fileprivate(set) var tabSpacing: CGFloat = 0.0
    open fileprivate(set) var selectedPage: Int?

    fileprivate var scrollView = WScrollView()
    fileprivate var pages = [WPage]()
    fileprivate var contentView = UIView()
    fileprivate var tabContainerView = UIView()
    fileprivate var separatorLine = UIView()
    fileprivate var selectionIndicatorView = WSelectionIndicatorView()
    fileprivate var selectedContainer: WTabView?
    fileprivate var tabViews = Array<WTabView>()
    fileprivate var isAnimating = false
    fileprivate weak var delegate: WPagingSelectorControlDelegate?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public convenience init(titles: Array<String>) {
        self.init(titles: titles, tabWidth: nil)
    }

    public init(titles: Array<String>, tabWidth: CGFloat?, tabSpacing: CGFloat = 0.0) {
        super.init(frame: CGRect.zero)

        for title in titles {
            let page = WPage(title: title, viewController: nil)
            pages.append(page)
        }

        if tabSpacing > 0.0 {
            self.tabSpacing = tabSpacing
        }

        if let tabWidth = tabWidth {
            widthMode = .static

            if (tabWidth >= MIN_TAB_WIDTH) {
                self.tabWidth = tabWidth
            } else {
                print("Invalid width: ", tabWidth, ". Defaulting to min tab width: ", MIN_TAB_WIDTH)
            }
        } else {
            widthMode = .dynamic
        }

        commonInit()
    }

    public convenience init(pages: Array<WPage>) {
        self.init(pages: pages, tabWidth: nil)
    }

    public init(pages: Array<WPage>, tabWidth: CGFloat?, tabSpacing: CGFloat = 0.0) {
        super.init(frame: CGRect.zero)

        self.pages = pages

        if tabSpacing > 0.0 {
            self.tabSpacing = tabSpacing
        }

        if let tabWidth = tabWidth {
            widthMode = .static

            if (tabWidth >= MIN_TAB_WIDTH) {
                self.tabWidth = tabWidth
            } else {
                print("Invalid width: ", tabWidth, ". Defaulting to min tab width: ", MIN_TAB_WIDTH)
            }
        } else {
            widthMode = .dynamic
        }

        commonInit()
    }

    open func commonInit() {
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.isScrollEnabled = true

        scrollView.isScrollEnabled = true
        accessibilityIdentifier = "pagingSelectorControl"

        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        
        addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(separatorLineHeight)
        }

        var contentWidth: CGFloat = 0.0
        if (widthMode == .static) {
            if pages.count > 1 {
                contentWidth = (tabWidth! * CGFloat(pages.count)) + (tabSpacing * (CGFloat(pages.count) - 1))
            } else {
                contentWidth = tabWidth! * CGFloat(pages.count)
            }
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)

            if (widthMode == .dynamic) {
                make.width.equalTo(scrollView)
            } else if (contentWidth > UIScreen.main.bounds.width) {
                make.width.equalTo(contentWidth)
            } else {
                make.width.equalTo(scrollView)
            }
        }

        contentView.addSubview(tabContainerView)
        tabContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)

            if (widthMode == .dynamic) {
                make.left.equalTo(contentView)
                make.width.equalTo(contentView)
            } else {
                make.width.equalTo(contentWidth)
                // TODO: Temporary solution. Will not work if the scroll view is not the size of the screen
                // Using the center works for non-scrollable number of tabs
                // Using left works for scrolling tabs
                if (contentWidth > UIScreen.main.bounds.width) {
                    make.left.equalTo(scrollView)
                } else {
                    make.centerX.equalTo(contentView.snp.centerX)
                }
            }
        }

        contentView.addSubview(selectionIndicatorView)

        isOpaque = false

        if (pages.count > 0) {
            for i in 0..<pages.count {
                let tab = WTabView(title: pages[i].title)
                tab.label.textColor = tabTextColor

                tab.tag = i
                tab.isUserInteractionEnabled = true

                tabContainerView.addSubview(tab)

                tabViews.append(tab)

                tab.snp.makeConstraints { (make) in
                    if i == 0 {
                        make.left.equalTo(tabContainerView)
                    } else {
                        make.left.equalTo(tabViews[i - 1].snp.right).offset(tabSpacing)
                    }

                    if widthMode == .dynamic {
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

        if (widthMode == .dynamic) {
            scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: contentView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: contentWidth, height: contentView.frame.size.height)
        }
    }

    @objc fileprivate func tappedTabItem(_ recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        if (index == selectedContainer!.tag || isAnimating) {
            return
        }
        moveToTabIndex(index)
    }

    open func moveToTabIndex(_ tabIndex: NSInteger) {
        selectedPage = tabIndex

        let newSelectedContainer = tabViews[tabIndex]

        selectedContainer?.label.font = UIFont.systemFont(ofSize: selectedContainer!.label.font.pointSize)
        newSelectedContainer.label.font = UIFont.boldSystemFont(ofSize: newSelectedContainer.label.font.pointSize)

        selectedContainer = newSelectedContainer
        scrollView.scrollRectToVisible(selectedContainer!.frame, animated: true)
        selectionIndicatorView.moveToSelection(selectedContainer!, numberOfSections: pages.count, contentView: contentView)

        delegate?.willChangeToTab?(self, tab: tabIndex)

        isAnimating = true
        UIView.animate(withDuration: ANIMATION_DURATION,
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

open class WPagingSelectorVC: WSideMenuContentVC, WPagingSelectorControlDelegate {
    open fileprivate(set) var pagingSelectorControl: WPagingSelectorControl?
    open var pagingControlHeight: CGFloat = DEFAULT_PAGING_SELECTOR_HEIGHT {
        didSet {
            setupUI()
        }
    }

    open var pagingControlSidePadding: CGFloat = DEFAULT_PAGING_SELECTOR_SIDE_PADDING {
        didSet {
            pagingControlConstraintsChanged()
        }
    }

    open var tabTextColor: UIColor = .black {
        didSet {
            pagingSelectorControl?.tabTextColor = tabTextColor
        }
    }
    
    open var separatorLineColor: UIColor = WThemeManager.sharedInstance.currentTheme.pagingSelectorSeparatorColor {
        didSet {
            pagingSelectorControl?.separatorLineColor = separatorLineColor
        }
    }
    
    open var separatorLineHeight: CGFloat = 1.0 {
        didSet {
            pagingSelectorControl?.separatorLineHeight = separatorLineHeight
        }
    }

    open var shadowColor: CGColor = UIColor.black.cgColor
    open var shadowRadius: CGFloat = 4
    open var shadowOpacity: Float = 0.3
    open var shadowAnimationDuration = 0.2
    open fileprivate(set) var mainContainerView = UIView()
    open fileprivate(set) var mainViewController: UIViewController?

    var currentPageIndex = 0
    var pageToSet: Int?
    var isShowingShadow = false
    
    open weak var delegate: WPagingSelectorVCDelegate?

    open var pages:[WPage] = [WPage]() {
        didSet {
            setupUI()
        }
    }

    open var tabWidth: CGFloat? {
        didSet {
            setupUI()
        }
    }

    open var tabSpacing: CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainContainerView)

        mainContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view)
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let page = pageToSet {
            setPage(index: page)
        }
    }

    open func setupUI() {
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

        pagingControlConstraintsChanged()

        if (pages.count > 0) {
            let newMainViewController = pages[0].viewController
            addViewControllerToContainer(mainContainerView, viewController: newMainViewController)

            self.mainViewController = newMainViewController
        }
    }

    public func pagingControlConstraintsChanged() {
        if let pagingSelectorControl = pagingSelectorControl {
            pagingSelectorControl.tabTextColor = tabTextColor
            pagingSelectorControl.separatorLineColor = separatorLineColor

            view.addSubview(pagingSelectorControl)

            pagingSelectorControl.snp.remakeConstraints { (make) in
                make.left.equalTo(view).offset(pagingControlSidePadding)
                make.right.equalTo(view).offset(-pagingControlSidePadding)
                make.height.equalTo(pagingControlHeight)
                make.top.equalTo(view)
            }

            mainContainerView.snp.remakeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.bottom.equalTo(view)
                make.top.equalTo(pagingSelectorControl.snp.bottom)
            }
        }
    }

    // Delegate methods
    func willChangeToTab(_ sender: WPagingSelectorControl, tab: Int) {
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
            mainViewController?.view.snp.remakeConstraints { (make) in
                if (tab < currentPageIndex) {
                    make.right.equalTo(mainContainerView.snp.left)
                } else {
                    make.left.equalTo(mainContainerView.snp.right)
                }
                make.top.equalTo(mainContainerView)
                make.bottom.equalTo(mainContainerView)
                make.width.equalTo(mainContainerView)
            }

            mainContainerView.layoutIfNeeded()

            mainViewController?.view.snp.remakeConstraints { (make) in
                make.left.equalTo(mainContainerView)
                make.top.equalTo(mainContainerView)
                make.bottom.equalTo(mainContainerView)
                make.right.equalTo(mainContainerView)
            }

            if oldMainViewController != nil {
                oldMainViewController?.view.snp.remakeConstraints { (make) in
                    if (tab > currentPageIndex) {
                        make.right.equalTo(mainContainerView.snp.left)
                    } else {
                        make.left.equalTo(mainContainerView.snp.right)
                    }
                    make.top.equalTo(mainContainerView)
                    make.bottom.equalTo(mainContainerView)
                    make.width.equalTo(mainContainerView)
                }
            }
            
            UIView.animate(withDuration: ANIMATION_DURATION,
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
    
    open func setShadow(_ enabled: Bool, animated: Bool = false) {
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
                animation.isRemovedOnCompletion = false
                
                self.pagingSelectorControl?.layer.add(animation, forKey: "shadowAnimation")
            } else {
                pagingSelectorControl?.layer.shadowOpacity = enabled ? shadowOpacity : 0.0
            }
        }
    }
}

extension WPagingSelectorVC : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
