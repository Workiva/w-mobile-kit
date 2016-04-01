//
//  WPagingSelector.swift
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

public class WPagingSelectorVC : UIControl {
    private var scrollView = WScrollView()
    private var sectionTitles = Array<String>()
    private var contentView = UIView()
    private var selectionIndicatorColor = UIColor()
    private var selectionIndicator = UIView()
    
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
        
        contentView.addSubview(selectionIndicator)
        selectionIndicator.snp_makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.width.equalTo(contentView).dividedBy(sectionTitles.count)
            make.height.equalTo(8)
            make.bottom.equalTo(contentView).offset(-1)
        }
        
        selectionIndicator.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        opaque = false
        selectionIndicatorColor = UIColor.whiteColor()
        
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
        }
    }
    
    func tappedTabItem(recognizer: UITapGestureRecognizer) {
        let newSelectedContainer = tabViews[(recognizer.view?.tag)!]
        
        selectedContainer.layer.opacity = 0.7
        
        newSelectedContainer.layer.opacity = 1.0
        
        selectedContainer = newSelectedContainer
        
        selectionIndicator.snp_remakeConstraints { (make) in
            make.left.equalTo(selectedContainer)
            make.width.equalTo(contentView).dividedBy(sectionTitles.count)
            make.height.equalTo(8)
            make.bottom.equalTo(contentView).offset(-1)
        }
        UIView.animateWithDuration(0.2, animations: { 
            self.layoutIfNeeded()
        })
        { (finished) in
            self.scrollView.scrollRectToVisible(self.selectedContainer.frame, animated: true)
        }
    }
}


