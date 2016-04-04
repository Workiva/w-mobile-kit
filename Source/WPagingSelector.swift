//
//  WPagingSelectorVC.swift
//  WMobileKit

import Foundation
import UIKit

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
            make.left.equalTo(selectionView).offset(20)
            make.width.equalTo(contentView).dividedBy(numberOfSections).offset(-40)
            make.height.equalTo(7)
            make.bottom.equalTo(contentView)
        }
    }
}

public class WPagingSelectorVC : UIControl {
    private var scrollView = WScrollView()
    private var sectionTitles = Array<String>()
    private var contentView = UIView()
    private var selectionIndicatorView = WSelectionIndicatorView()
    
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
            make.bottom.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
            if (sectionTitles.count <= 3) {
                make.width.equalTo(scrollView)
                make.right.equalTo(scrollView)
            } else {
                make.width.equalTo(scrollView).multipliedBy((CGFloat)(sectionTitles.count) / 3.0 - 0.1)
            }
        }
        
        contentView.addSubview(selectionIndicatorView)

        opaque = false

        if (sectionTitles.count > 0) {
            for i in 0..<sectionTitles.count {
                let container = UIView()
                container.tag = i
                let label = UILabel()
                
                label.text = sectionTitles[i]
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                
                contentView.addSubview(container)
                container.addSubview(label)
                
                tabViews.append(container)
                
                container.snp_makeConstraints { (make) in
                    if (i == 0) {
                        make.left.equalTo(contentView)
                    } else {
                        make.left.equalTo(tabViews[i - 1].snp_right)
                    }
                    
                    make.width.equalTo(contentView).dividedBy(sectionTitles.count)
                    make.height.equalTo(contentView)
                    make.top.equalTo(contentView)
                }
                
                label.snp_makeConstraints { (make) in
                    make.left.equalTo(container)
                    make.width.equalTo(container)
                    make.height.equalTo(container)
                    make.top.equalTo(container)
                }
                
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(WPagingSelectorVC.tappedTabItem(_:)))
                container.addGestureRecognizer(recognizer)
                
                if (i == 0) {
                    selectedContainer = container
                } else {
                    container.layer.opacity = 0.7
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


