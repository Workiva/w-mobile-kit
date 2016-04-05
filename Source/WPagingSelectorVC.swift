//
//  WPagingSelectorControl.swift
//  WMobileKit

import Foundation
import UIKit

let MIN_TAB_WIDTH = 20
let SELECTED_OPACITY:Float = 0.7
let UNSELECTED_OPACITY:Float = 0.2

public enum WPagingWidthMode {
    case Static
    case Dynamic
}

public class WScrollView : UIScrollView {
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
        if (!self.dragging) {
            nextResponder()?.touchesEnded(touches, withEvent: event)
        } else {
            super.touchesEnded(touches, withEvent: event)
        }
    }
}

public class WSelectionIndicatorView : UIView {
    public init(alpha: CGFloat) {
        super.init(frame: CGRectMake(0, 0, 100, 50))

        self.alpha = alpha
    }

    override convenience init(frame: CGRect) {
        self.init(alpha: 0.7)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func moveToSelection(selectionView: UIView, numberOfSections: NSInteger, contentView: UIView) {
        snp_remakeConstraints { (make) in
            make.left.equalTo(selectionView).offset(6)
            make.width.equalTo(selectionView).offset(-12)
            make.height.equalTo(7)
            make.bottom.equalTo(contentView)
        }
    }
}

public class WTabView : UIView {
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
        label.textColor = UIColor.whiteColor()
        
        addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.top.equalTo(self)
        }
        
        layer.opacity = UNSELECTED_OPACITY
    }
}

public class WPagingSelectorControl : UIControl {
    // Accessable properties
    public private(set) var widthMode: WPagingWidthMode = .Dynamic
    public private(set) var tabWidth: Int?
    public private(set) var selectedPage: Int?

    private var scrollView = WScrollView()
//    private var sectionTitles = Array<String>()
    private var pages = [WPage]()
    private var contentView = UIView()
    private var tabContainerView = UIView()
    private var selectionIndicatorView = WSelectionIndicatorView()
    private var selectedContainer = UIView()
    private var tabViews = Array<UIView>()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }

    public convenience init(titles: Array<String>) {
        self.init(titles: titles, tabWidth: nil)
    }

    public init(titles: Array<String>, tabWidth: Int?) {
        super.init(frame: CGRectZero)

        for title in titles {
            var page = WPage(title: title, viewController: nil)
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
        
        scrollView.addSubview(contentView);
        contentView.snp_makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
            
            if (widthMode == .Dynamic) {
                make.width.equalTo(scrollView)
            } else {
                make.width.equalTo(scrollView)
            }
        }
        
        contentView.addSubview(tabContainerView)
        tabContainerView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)
            
            if (widthMode == .Dynamic) {
                make.width.equalTo(contentView)
                make.left.equalTo(contentView)
            } else {

                let contentWidth:CGFloat = CGFloat(tabWidth! * pages.count)
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
        moveToTabIndex((recognizer.view?.tag)!)

        // TODO: Tell delegate that it was tapped
        // Trigger which view to hide/show
    }

    public func moveToTabIndex(tabIndex: NSInteger) {
        selectedPage = tabIndex

        let newSelectedContainer = tabViews[tabIndex]

        selectedContainer.layer.opacity = UNSELECTED_OPACITY

        newSelectedContainer.layer.opacity = SELECTED_OPACITY

        selectedContainer = newSelectedContainer

        selectionIndicatorView.moveToSelection(selectedContainer, numberOfSections: pages.count, contentView: contentView)

        UIView.animateWithDuration(0.2, animations: {
            self.layoutIfNeeded()
            })
        { (finished) in
            self.scrollView.scrollRectToVisible(self.selectedContainer.frame, animated: true)
        }
    }
}

public struct WPage {
    public var title:String = ""
    public var viewController:WSideMenuContentVC?

    public init(title: String) {
        self.init(title: title, viewController: nil)
    }

    public init(title: String, viewController: WSideMenuContentVC?) {
        self.title = title
    }
}

public class WPagingSelectorVC: WSideMenuContentVC {
    public private(set) var pagingSelectorControl:WPagingSelectorControl?

//    private var _pages = [WPage]()
    public var pages:[WPage] = [WPage]() {


        didSet {
//            _pages = newValue

            if let pagingSelectorControl = pagingSelectorControl {
                pagingSelectorControl.removeFromSuperview()
            }

            pagingSelectorControl = WPagingSelectorControl(pages:pages, tabWidth: 90)

            view.addSubview(pagingSelectorControl!);
            pagingSelectorControl!.snp_makeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(50)
                make.top.equalTo(view)
            }

            pagingSelectorControl!.layoutSubviews()

            // TODO: Show default view controller 

            // TODO: Change on tapped action
        }
    }



//    public convenience init(pages: WPage...) {
//        self.init()
//        self.pages = pages
//    }

//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let pagingSelectorControl = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"], tabWidth: 90)
//
//        view.addSubview(pagingSelectorControl);
//        pagingSelectorControl.snp_makeConstraints { (make) in
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.height.equalTo(50)
//            make.top.equalTo(view.snp_bottom)
//        }
//
//        pagingSelectorControl.layoutSubviews()
//
//        updateUI()
//    }
//
//    public func updateUI() {
//    }
    public override func viewDidLoad() {
        super.viewDidLoad()

//        let pagingSelectorControl = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"], tabWidth: 90)
//
//        view.addSubview(pagingSelectorControl);
//        pagingSelectorControl.snp_makeConstraints { (make) in
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.height.equalTo(50)
//            make.top.equalTo(view)
//        }
//
//        pagingSelectorControl.layoutSubviews()


//    let tabLayout = WPagingSelectorControl(titles: ["Recent", "All Files"])
//
//    view.addSubview(tabLayout);
//    tabLayout.snp_makeConstraints { (make) in
//    make.left.equalTo(view)
//    make.right.equalTo(view)
//    make.height.equalTo(50)
//    make.top.equalTo(view)
//    }
//
//    tabLayout.layoutSubviews()
//
//    let tabLayout2 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"])
//
//    view.addSubview(tabLayout2);
//    tabLayout2.snp_makeConstraints { (make) in
//    make.left.equalTo(view)
//    make.right.equalTo(view)
//    make.height.equalTo(50)
//    make.top.equalTo(tabLayout.snp_bottom)
//    }
//
//    tabLayout2.layoutSubviews()
//
//    let tabLayout3 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"], tabWidth: 90)
//
//    view.addSubview(tabLayout3);
//    tabLayout3.snp_makeConstraints { (make) in
//    make.left.equalTo(view)
//    make.right.equalTo(view)
//    make.height.equalTo(50)
//    make.top.equalTo(tabLayout2.snp_bottom)
//    }
//
//    tabLayout3.layoutSubviews()
//
//    let tabLayout4 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff"], tabWidth: 90)
//
//    view.addSubview(tabLayout4);
//    tabLayout4.snp_makeConstraints { (make) in
//    make.left.equalTo(view)
//    make.right.equalTo(view)
//    make.height.equalTo(50)
//    make.top.equalTo(tabLayout3.snp_bottom)
//    }
//
//    tabLayout4.layoutSubviews()
//
//    let tabLayout5 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff", "Too many"], tabWidth: 90)
//
//    view.addSubview(tabLayout5);
//    tabLayout5.snp_makeConstraints { (make) in
//    make.left.equalTo(view)
//    make.right.equalTo(view)
//    make.height.equalTo(50)
//    make.top.equalTo(tabLayout4.snp_bottom)
//    }
//
//    tabLayout5.layoutSubviews()
}

public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    // Set the WSideMenu delegate when the VC appears
    sideMenuController()?.delegate = self
}

}



