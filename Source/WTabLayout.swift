//
//  WTabLayout.swift
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

public class WTabLayout : UIControl {
    private var scrollView = WScrollView()
    private var sectionTitles = Array<String>()
    private var contentView = UIView()
    private var selectionIndicatorColor = UIColor()
    private var selectionIndicator = UIView()
    
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
            make.right.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        contentView.addSubview(selectionIndicator)
        selectionIndicator.snp_makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.width.equalTo(contentView).dividedBy(2)
            make.height.equalTo(8)
            make.bottom.equalTo(contentView).offset(-1)
        }
        
        selectionIndicator.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        opaque = false
        selectionIndicatorColor = UIColor.whiteColor()
        
        switch sectionTitles.count {
        case 2:
            let container1 = UIView()
            let container2 = UIView()
            container1.tag = 0
            container2.tag = 1
            
            let label1 = UILabel()
            let label2 = UILabel()
            
            label1.text = sectionTitles[0]
            label2.text = sectionTitles[1]
            label1.textAlignment = NSTextAlignment.Center
            label2.textAlignment = NSTextAlignment.Center
            label1.textColor = UIColor.whiteColor()
            label2.textColor = UIColor.whiteColor()
            
            contentView.addSubview(container1)
            contentView.addSubview(container2)
            container1.addSubview(label1)
            container2.addSubview(label2)
            
            tabViews.append(container1)
            tabViews.append(container2)
            
            container1.snp_makeConstraints { (make) in
                make.left.equalTo(contentView)
                make.width.equalTo(contentView).dividedBy(2)
                make.height.equalTo(contentView)
                make.top.equalTo(contentView)
            }
            
            container2.snp_makeConstraints { (make) in
                make.width.equalTo(contentView).dividedBy(2)
                make.right.equalTo(contentView)
                make.height.equalTo(contentView)
                make.top.equalTo(contentView)
            }
            
            label1.snp_makeConstraints { (make) in
                make.left.equalTo(container1)
                make.width.equalTo(container1)
                make.height.equalTo(container1)
                make.top.equalTo(container1)
            }
            
            label2.snp_makeConstraints { (make) in
                make.width.equalTo(container2)
                make.right.equalTo(container2)
                make.height.equalTo(container2)
                make.top.equalTo(container2)
            }
            
            let recognizer1 = UITapGestureRecognizer(target: self, action: "tappedTabItem:")
            let recognizer2 = UITapGestureRecognizer(target: self, action: "tappedTabItem:")
            container1.addGestureRecognizer(recognizer1)
            container2.addGestureRecognizer(recognizer2)
            
            break
        default:
            break
        }
    }
    
    func tappedTabItem(recognizer: UITapGestureRecognizer) {        
        selectionIndicator.snp_remakeConstraints { (make) in
            make.left.equalTo(tabViews[(recognizer.view?.tag)!])
            make.width.equalTo(contentView).dividedBy(2)
            make.height.equalTo(8)
            make.bottom.equalTo(contentView).offset(-1)
        }
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
    }
}