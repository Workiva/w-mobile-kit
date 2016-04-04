//
//  WPagingSelectorControl.swift
//  WMobileKit

import Foundation
import UIKit

let MIN_TAB_WIDTH = 20

private enum WPagingWidthMode {
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
        self.snp_remakeConstraints { (make) in
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
        
        layer.opacity = 0.7
    }
}

public class WPagingSelectorControl : UIControl {
    private var scrollView = WScrollView()
    private var sectionTitles = Array<String>()
    private var contentView = UIView()
    private var tabContainerView = UIView()
    private var selectionIndicatorView = WSelectionIndicatorView()
    private var widthMode: WPagingWidthMode = .Dynamic
    private var tabWidth: Int?
    
    private var selectedContainer = UIView()
    
    private var tabViews = Array<UIView>()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public init(titles: Array<String>) {
        super.init(frame: CGRectZero)
        sectionTitles = titles
        commonInit()
    }
    
    public init(titles: Array<String>, tabWidth: Int) {
        super.init(frame: CGRectZero)
        sectionTitles = titles
        widthMode = .Static
        if (tabWidth >= MIN_TAB_WIDTH) {
            self.tabWidth = tabWidth
        } else {
            print("Invalid width: ", tabWidth, ". Defaulting to min tab width: ", MIN_TAB_WIDTH)
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

                var contentWidth:CGFloat = CGFloat(tabWidth! * sectionTitles.count)
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

        if (sectionTitles.count > 0) {
            for i in 0..<sectionTitles.count {
                let tab = WTabView(title: sectionTitles[i])
                                
                tab.tag = i
                tab.userInteractionEnabled = true
                
                tabContainerView.addSubview(tab)
                
                tabViews.append(tab)
                
                tab.snp_makeConstraints { (make) in
                    if (i == 0) {
                        make.left.equalTo(tabContainerView)
                    } else {
                        make.left.equalTo(tabViews[i - 1].snp_right)
                    }
                    
                    if (widthMode == .Dynamic) {
                        make.width.equalTo(tabContainerView).dividedBy(sectionTitles.count)
                    } else {
                        make.width.equalTo(tabWidth!)
                    }
                    
                    make.height.equalTo(tabContainerView)
                    make.top.equalTo(tabContainerView)
                }
                
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(WPagingSelectorControl.tappedTabItem(_:)))
                tab.addGestureRecognizer(recognizer)
                
                if (i == 0) {
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
            scrollView.contentSize = CGSize(width: CGFloat(tabWidth! * sectionTitles.count), height: contentView.frame.size.height)
        }
    }
    
    func tappedTabItem(recognizer: UITapGestureRecognizer) {
        moveToTabIndex((recognizer.view?.tag)!)
    }

    func moveToTabIndex(tabIndex: NSInteger) {
        let newSelectedContainer = tabViews[tabIndex]

        selectedContainer.layer.opacity = 0.7

        newSelectedContainer.layer.opacity = 1.0

        selectedContainer = newSelectedContainer

        selectionIndicatorView.moveToSelection(selectedContainer, numberOfSections: sectionTitles.count, contentView: contentView)

        UIView.animateWithDuration(0.2, animations: {
            self.layoutIfNeeded()
            })
        { (finished) in
            self.scrollView.scrollRectToVisible(self.selectedContainer.frame, animated: true)
        }
    }
}


