//
//  WPagingSelectorVC.swift
//  WMobileKit

import Foundation
import UIKit

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
            make.left.equalTo(selectionView)
            make.width.equalTo(selectionView)
            make.height.equalTo(7)
            make.bottom.equalTo(contentView)
        }
    }
}

public class WPagingSelectorVC : UIControl {
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
    
    public init(titles: Array<String>, withTabWidth: Int) {
        super.init(frame: CGRectZero)
        sectionTitles = titles
        widthMode = .Static
        tabWidth = withTabWidth
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
                make.width.equalTo(tabWidth! * sectionTitles.count)
                make.centerX.equalTo(contentView.snp_centerX)
            }
        }
        
        contentView.addSubview(selectionIndicatorView)

        opaque = false

        if (sectionTitles.count > 0) {
            for i in 0..<sectionTitles.count {
                let label = UILabel()
                
                label.text = sectionTitles[i]
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                label.tag = i
                label.userInteractionEnabled = true
                
                tabContainerView.addSubview(label)
                
                tabViews.append(label)
                
                label.snp_makeConstraints { (make) in
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
                
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(WPagingSelectorVC.tappedTabItem(_:)))
                label.addGestureRecognizer(recognizer)
                
                if (i == 0) {
                    selectedContainer = label
                } else {
                    label.layer.opacity = 0.7
                }
            }

            layoutIfNeeded()

            moveToTabIndex(0)
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


