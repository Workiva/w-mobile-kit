//
//  WActionSheet.swift
//  Pods

import Foundation
import UIKit
import SnapKit

public class WActionSheetVC : UIViewController {
    private var darkView = UIView(frame: CGRectZero)
    private var containerView = UIView(frame: CGRectZero)
    private var topLine = UIView(frame: CGRectZero)
//    private var collectionView = UICollectionView()
    private var sections = [UIView]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateIn()
    }
    
    public func commonInit() {
        NSLog("Common Init called!")
        view.addSubview(darkView)
        
        darkView.snp_makeConstraints { (make) in
            make.left.equalTo(UIScreen.mainScreen().bounds.minX)
            make.right.equalTo(UIScreen.mainScreen().bounds.maxX)
            make.top.equalTo(UIScreen.mainScreen().bounds.minY)
            make.bottom.equalTo(UIScreen.mainScreen().bounds.maxY)
        }
        
        darkView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
        
        let recognizer = UITapGestureRecognizer(target: self, action: "animateOut")
        darkView.addGestureRecognizer(recognizer)
        
        view.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        containerView.backgroundColor = UIColor.whiteColor()
        
//        containerView.addSubview(collectionView)
//        collectionView.snp_makeConstraints { (make) in
//            make.left.equalTo(containerView)
//            make.right.equalTo(containerView)
//            make.top.equalTo(containerView)
//            make.bottom.equalTo(containerView)
//        }
//        
//        collectionView.backgroundColor = UIColor.whiteColor()
        
        view.layoutIfNeeded()
        
    }
    
    public func animateIn() {
        view.addSubview(containerView)
        containerView.snp_remakeConstraints { (make) in
            make.bottom.equalTo(view).offset(20)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(220)
        }
        
        UIView.animateWithDuration(0.35, delay: 0.1,
                       usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 5.0,
                                      options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {
                                        self.view.layoutIfNeeded()
                                   },
                                   completion: nil)
    }
    
    public func animateOut() {
        view.addSubview(containerView)
        containerView.snp_remakeConstraints { (make) in
            make.top.equalTo(view.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        UIView.animateWithDuration(0.2, animations: { 
            self.view.layoutIfNeeded()
            }) { (finished) in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

public enum ActionStyle {
    case Cancel
    case Action
    case Destructive
}

public class WActionCell : UICollectionViewCell {
    private var title : String?
    private var subTitle : String?
    private var actionStyle : ActionStyle?
    private var selectBar = UIView(frame: CGRectZero)
    
    
}