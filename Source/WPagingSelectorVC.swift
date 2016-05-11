//
//  WPagingSelectorControl.swift
//  WMobileKit

import Foundation
import UIKit

let DEFAULT_TAB_WIDTH = 90
let MIN_TAB_WIDTH = 20
let ANIMATION_DURATION = 0.2
let SELECTION_INDICATOR_VIEW_HEIGHT = 3
public let DEFAULT_PAGING_SELECTOR_HEIGHT = 44

public enum WPagingWidthMode {
    case Static, Dynamic
}

@objc protocol WPagingSelectorVCDelegate: class {
    optional func willChangeToTab(sender: WPagingSelectorControl, tab: Int)
    optional func didChangeToTab(sender: WPagingSelectorControl, tab: Int)
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

    public private(set) var widthMode: WPagingWidthMode = .Dynamic
    public private(set) var tabWidth: Int?
    public private(set) var selectedPage: Int?

    private var scrollView = WScrollView()
    private var pages = [WPage]()
    private var contentView = UIView()
    private var tabContainerView = UIView()
    private var selectionIndicatorView = WSelectionIndicatorView()
    private var selectedContainer: WTabView?
    private var tabViews = Array<WTabView>()
    private var isAnimating = false
    private weak var delegate: WPagingSelectorVCDelegate?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public convenience init(titles: Array<String>) {
        self.init(titles: titles, tabWidth: nil)
    }

    public init(titles: Array<String>, tabWidth: Int?) {
        super.init(frame: CGRectZero)

        for title in titles {
            let page = WPage(title: title, viewController: nil)
            pages.append(page)
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

    public init(pages: Array<WPage>, tabWidth: Int?) {
        super.init(frame: CGRectZero)

        self.pages = pages

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

        var contentWidth:CGFloat = CGFloat(0)
        if (widthMode == .Static) {
            contentWidth = CGFloat(tabWidth! * pages.count)
        }

        scrollView.addSubview(contentView);
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
                        make.left.equalTo(tabViews[i - 1].snp_right)
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
            // Set width to number of tabs * tab width
            scrollView.contentSize = CGSize(width: CGFloat(tabWidth! * pages.count), height: contentView.frame.size.height)
        }
    }

    @objc private func tappedTabItem(recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        if (index == selectedContainer!.tag || isAnimating) {
            return
        }
        moveToTabIndex(index)

        delegate?.willChangeToTab?(self, tab: index)
    }

    public func moveToTabIndex(tabIndex: NSInteger) {
        selectedPage = tabIndex

        let newSelectedContainer = tabViews[tabIndex]

        selectedContainer?.label.font = UIFont.systemFontOfSize(selectedContainer!.label.font.pointSize)

        newSelectedContainer.label.font = UIFont.boldSystemFontOfSize(newSelectedContainer.label.font.pointSize)

        selectedContainer = newSelectedContainer

        scrollView.scrollRectToVisible(selectedContainer!.frame, animated: true)

        selectionIndicatorView.moveToSelection(selectedContainer!, numberOfSections: pages.count, contentView: contentView)

        isAnimating = true
        UIView.animateWithDuration(ANIMATION_DURATION,
            animations: {
                self.layoutIfNeeded()
            },
            completion: { finished in
                self.delegate?.didChangeToTab?(self, tab: tabIndex)
                self.isAnimating = false
        })
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

public class WPagingSelectorVC: WSideMenuContentVC, WPagingSelectorVCDelegate {
    public private(set) var pagingSelectorControl: WPagingSelectorControl?
    public var pagingControlHeight: Int = DEFAULT_PAGING_SELECTOR_HEIGHT {
        didSet {
            if (pagingSelectorControl != nil) {
                pagingSelectorControl!.removeFromSuperview()

                setupUI()
            }
        }
    }

    public var tabTextColor: UIColor = .blackColor() {
        didSet {
            pagingSelectorControl?.tabTextColor = tabTextColor
        }
    }

    var mainViewController: UIViewController?
    var mainContainerView = UIView(frame: CGRectZero)
    var currentPageIndex = 0

    public var pages:[WPage] = [WPage]() {
        didSet {
            if let pagingSelectorControl = pagingSelectorControl {
                pagingSelectorControl.removeFromSuperview()
            }

            setupUI()
        }
    }

    public var tabWidth: Int? {
        didSet {
            if (pagingSelectorControl != nil) {
                pagingSelectorControl!.removeFromSuperview()

                setupUI()
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainContainerView);

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

    private func setupUI() {
        if (tabWidth == nil || tabWidth >= MIN_TAB_WIDTH) {
            pagingSelectorControl = WPagingSelectorControl(pages: pages, tabWidth: tabWidth)
        } else {
            pagingSelectorControl = WPagingSelectorControl(pages: pages, tabWidth: DEFAULT_TAB_WIDTH)
        }

        pagingSelectorControl?.delegate = self

        if let pagingSelectorControl = pagingSelectorControl {
            pagingSelectorControl.tabTextColor = tabTextColor

            view.addSubview(pagingSelectorControl);
            pagingSelectorControl.snp_makeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
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

        if let mainViewController = pages[0].viewController {
            addViewControllerToContainer(mainContainerView, viewController: mainViewController)

            self.mainViewController = mainViewController
        }
    }

    // Delegate methods
    func willChangeToTab(sender: WPagingSelectorControl, tab: Int) {
        // Store old main view controller to remove after animation
        let oldMainViewController = mainViewController

        if let newMainViewController = pages[tab].viewController {
            mainViewController = newMainViewController
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

            oldMainViewController

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
        }
    }

    @objc internal func didChangeToTab(sender: WPagingSelectorControl, tab: Int) {
        currentPageIndex = tab
    }
}
