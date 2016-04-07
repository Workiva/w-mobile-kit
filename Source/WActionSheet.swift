//
//  WActionSheet.swift
//  Pods

import Foundation
import UIKit
import SnapKit

public enum ActionStyle {
    case Cancel
    case Action
    case Destructive
}

public class WActionSheetVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var darkView = UIView(frame: CGRectZero)
    private var containerView = UIView(frame: CGRectZero)
    private var topLine = UIView(frame: CGRectZero)
    private var collectionView : UICollectionView?
    private var cells = [Int: Array<WAction>]()
    public var hasCancel = false {
        didSet {
            if (hasCancel) {
                if (cells[1] == nil) {
                    cells[1] = [WAction]()
                }
                let cancelCell = WAction(title: "Cancel", subtitle: nil, style: ActionStyle.Cancel)
                cells[1]?.insert(cancelCell, atIndex: 0)
            }
        }
    }

    public var titleString: String? {
        didSet {
//            let titleCell = WAction(title: titleString!)
//            if (cells[2] == nil) {
//                cells[2] = [WAction]()
//            }
//            cells[2]!.insert(titleCell, atIndex: 0)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateIn()
    }
    
    public func commonInit() {
        view.addSubview(darkView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: "animateOut")
        darkView.addGestureRecognizer(recognizer)
        
        view.addSubview(containerView)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView?.backgroundColor = UIColor(hex: 0xC3C3C3)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.delaysContentTouches = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.registerClass(WHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView?.registerClass(WCollectionViewCell.self, forCellWithReuseIdentifier: "ActionCell")
        
        containerView.addSubview(collectionView!)
        containerView.addSubview(topLine)
        containerView.layer.opacity = 0.8
        
        setupUI(false)
    }
    
    public func setupUI(animated: Bool) {
        containerView.snp_remakeConstraints { (make) in
            if (animated) {
                make.top.equalTo(view.snp_bottom)
            } else {
                make.bottom.equalTo(view)
            }
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo((cells[0]!.count + (titleString != nil ? 1 : 0)) * 50 + (hasCancel ? 56 : 0))
        }
        containerView.backgroundColor = UIColor.whiteColor()
        
        darkView.snp_remakeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(containerView.snp_top)
        }
        darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        collectionView?.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        
        topLine.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
            make.height.equalTo(2)
        }
        topLine.backgroundColor = UIColor(hex: 0x42AD48)
        
        view.layoutIfNeeded()
        
        if (animated) {
            containerView.snp_remakeConstraints { (make) in
                make.bottom.equalTo(view)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo((cells[0]!.count + (titleString != nil ? 1 : 0)) * 50 + (hasCancel ? 56 : 0))
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
    }
    
    public func animateIn() {
        setupUI(true);
    }
    
    public func animateOut() {
        view.addSubview(containerView)
        containerView.snp_remakeConstraints { (make) in
            make.top.equalTo(view.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        UIView.animateWithDuration(0.2, animations: { 
            self.view.layoutIfNeeded()
            }) { (finished) in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    public func addAction(title: String) {
        addAction(title, subtitle: nil)
    }
    
    public func addAction(title: String, subtitle: String?) {
        addAction(title, subtitle: subtitle, style: ActionStyle.Action)
    }
    
    public func addAction(title: String, subtitle: String?, style: ActionStyle?) {
        let newCell = WAction(title: title, subtitle: subtitle, style: style)
        
        if (cells[0] == nil) {
            cells[0] = Array<WAction>()
        }
        cells[0]?.append(newCell)
        
        setupUI(false)
        
        collectionView?.reloadData()
    }
    
    public func actionForIndexPath(indexPath: NSIndexPath) -> WAction {
        let actionCells = cells[indexPath.section]
        return actionCells![indexPath.row]
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells[section]!.count
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 + (hasCancel ? 1 : 0)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : WCollectionViewCell
    
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActionCell", forIndexPath: indexPath) as! WCollectionViewCell
        let action = actionForIndexPath(indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        cell.actionInfo = action
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell.selectBar.hidden = false
        }
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 50)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if (section == 0) {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(6, 0, 0, 0)
        }
    }

    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header : WCollectionViewCell?
        if (kind == UICollectionElementKindSectionHeader) {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! WHeaderCell
            header?.actionInfo = WAction(title: titleString!)
            header?.backgroundColor = UIColor.whiteColor()
        }
        
        if (kind == UICollectionElementKindSectionFooter) {
            // do something for footer?
        }
        return header!
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSizeMake(collectionView.bounds.width, 50)
        } else {
            return CGSizeZero
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! WCollectionViewCell
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { 
            cell.backgroundColor = UIColor.redColor()
            }, completion: nil)
        
        NSLog("Called highlight for " + cell.actionInfo!.title!)
    }
    
    public func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! WCollectionViewCell
        UIView.animateWithDuration(0.1) {
            //cell.backgroundColor = UIColor.whiteColor()
        }
        NSLog("Called unhighlight for " + cell.actionInfo!.title!)
    }
}

// Collection Cell

public class WAction {
    private var title : String?
    private var subtitle : String?
    private var actionStyle : ActionStyle?
    
    public convenience init(title: String) {
        self.init(title: title, subtitle : nil, style: ActionStyle.Action)
    }
    
    public convenience init(title: String, subtitle: String?) {
        self.init(title: title, subtitle : subtitle, style: ActionStyle.Action)
    }
    
    public init(title: String, subtitle: String?, style: ActionStyle?) {
        self.title = title
        self.subtitle = subtitle
        self.actionStyle = style
    }
}

public class WCollectionViewCell : UICollectionViewCell {
    private var actionInfo : WAction? {
        didSet {
            commonInit()
        }
    }
    
    private var selectBar = UIView(frame: CGRectZero)
    private var separatorBar = UIView(frame: CGRectZero)
    private var subtitleLabel : UILabel?
    private var titleLabel : UILabel?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public init(action: WAction) {
        super.init(frame: CGRectZero)
        
        self.actionInfo = action
    }
    
    public func commonInit() {
        if (!self.subviews.contains(selectBar)) {
            addSubview(selectBar)
        }
        selectBar.snp_removeConstraints()
        selectBar.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(10)
        }
        selectBar.backgroundColor = UIColor(hex: 0x0F7F40)
        selectBar.hidden = true
        
        if (!self.subviews.contains(separatorBar)) {
            addSubview(separatorBar)
        }
        separatorBar.snp_removeConstraints()
        separatorBar.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        separatorBar.backgroundColor = UIColor(hex: 0xC3C3C3)
        
        if let subtitle = actionInfo?.subtitle {
            if subtitleLabel == nil {
                subtitleLabel = UILabel(frame: CGRectZero)
                addSubview(subtitleLabel!)
            } else {
                subtitleLabel?.text = subtitle
                subtitleLabel?.font = UIFont(name: "Sinhala Sangam MN", size: 12)
                if (actionInfo?.actionStyle == ActionStyle.Destructive) {
                    subtitleLabel?.textColor = UIColor(hex: 0xEE2724)
                } else {
                    subtitleLabel?.textColor = UIColor(hex: 0x707070)
                }
                
                subtitleLabel?.snp_removeConstraints()
            }
            
            subtitleLabel?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self).offset(22)
                make.right.equalTo(self)
                make.height.equalTo(14)
                make.bottom.equalTo(self).offset(-12)
            })
            subtitleLabel?.text = subtitle
        }
        
        if let title = actionInfo?.title {
            if titleLabel == nil {
                titleLabel = UILabel(frame: CGRectZero)
                addSubview(titleLabel!)
            } else {
                titleLabel?.text = title
                titleLabel?.font = UIFont(name: "Sinhala Sangam MN", size: 14)
                if (actionInfo?.actionStyle == ActionStyle.Cancel) {
                    titleLabel?.textColor = UIColor(hex: 0x42AD48)
                } else if (actionInfo?.actionStyle == ActionStyle.Destructive) {
                    titleLabel?.textColor = UIColor(hex: 0xEE2724)
                } else {
                    titleLabel?.textColor = UIColor(hex: 0x444444)
                }

                titleLabel?.snp_removeConstraints()
            }
            
            titleLabel?.snp_makeConstraints(closure: { (make) in
                make.height.equalTo(16)
                
                if (actionInfo?.actionStyle == ActionStyle.Cancel) {
                    make.centerX.equalTo(self)
                } else {
                    make.left.equalTo(self).offset(22)
                    make.right.equalTo(self)
                }
                
                if actionInfo?.subtitle != nil {
                    make.top.equalTo(self).offset(12)
                } else {
                    make.centerY.equalTo(self)
                }
            })
        }
        
        layoutIfNeeded()
    }
}

// Has action handler when tapped
public class WActionCell : WCollectionViewCell {
//    public init(title: String, subtitle: String?, style: ActionStyle?, handler: ) {
//        
//    }
}

public class WHeaderCell : WCollectionViewCell {
    public override func commonInit() {
        super.commonInit()
        
        if let title = actionInfo?.title {
            if titleLabel == nil {
                titleLabel = UILabel(frame: CGRectZero)
                addSubview(titleLabel!)
            }
            titleLabel?.text = title
            titleLabel?.font = UIFont(name: "Sinhala Sangam MN", size: 16)
            titleLabel?.textColor = UIColor(hex: 0x444444)
            
            titleLabel?.snp_removeConstraints()
            
            titleLabel?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self).offset(18)
                make.right.equalTo(self)
                make.height.equalTo(18)
                make.centerY.equalTo(self)
            })
        }
        
        if subtitleLabel != nil {
            subtitleLabel?.removeFromSuperview()
        }
    }
}