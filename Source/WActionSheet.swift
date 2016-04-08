//
//  WActionSheet.swift
//  Pods

import Foundation
import UIKit
import SnapKit

public enum ActionStyle {
    case Cancel
    case Normal
    case Destructive
}

public enum SheetStyle {
    case Action
    case Selection
}

public class WActionSheetVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var darkView = UIView(frame: CGRectZero)
    private var containerView = UIView(frame: CGRectZero)
    private var topLine = UIView(frame: CGRectZero)
    private var tableView : UITableView?
    private var cells = [Int: Array<WAction>]()
   
    public var sheetStyle = SheetStyle.Action
    public var selectedIndex : Int?
    
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

    public var titleString: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .OverFullScreen
        modalTransitionStyle = .CrossDissolve
        providesPresentationContextTransitionStyle = true
        view.window?.windowLevel = UIWindowLevelStatusBar + 10
        
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
        
        tableView = UITableView(frame: CGRectZero)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.delaysContentTouches = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.scrollEnabled = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView?.registerClass(WHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView?.registerClass(WTableViewCell.self, forCellReuseIdentifier: "ActionCell")
        
        containerView.addSubview(tableView!)
        
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
        
        tableView?.snp_remakeConstraints { (make) in
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
        animateOut(0)
    }
    
    public func animateOut(delay: NSTimeInterval) {
        view.addSubview(containerView)
        containerView.snp_remakeConstraints { (make) in
            make.top.equalTo(view.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        UIView.animateWithDuration(0.2, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
            self.view.layoutIfNeeded()
            }) { (finished) in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    public func addAction(title: String) {
        addAction(title, subtitle: nil)
    }
    
    public func addAction(title: String, subtitle: String?) {
        addAction(title, subtitle: subtitle, style: ActionStyle.Normal)
    }
    
    public func addAction(title: String, subtitle: String?, style: ActionStyle?) {
        let newCell = WAction(title: title, subtitle: subtitle, style: style)
        
        if (cells[0] == nil) {
            cells[0] = Array<WAction>()
        }
        cells[0]?.append(newCell)
        
        setupUI(false)
        
        tableView?.reloadData()
    }
    
    public func actionForIndexPath(indexPath: NSIndexPath) -> WAction {
        let actionCells = cells[indexPath.section]
        return actionCells![indexPath.row]
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section]!.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + (hasCancel ? 1 : 0)
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : WTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as! WTableViewCell

        let action = actionForIndexPath(indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        cell.actionInfo = action
        
        if let selectedIndex = selectedIndex {
            if (indexPath.row == selectedIndex && indexPath.section == 0 && sheetStyle == .Selection) {
                cell.selectBar.hidden = false
            }
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header : WHeaderView?
        if (section == 0) {
            header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! WHeaderView
            header?.actionInfo = WAction(title: titleString!)
            header?.backgroundColor = UIColor.whiteColor()
        } else {
            header = UIView(frame: CGRectZero) as UITableViewHeaderFooterView
        }
        return header!
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 50
        } else {
            return 6
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            // selected action
            if (sheetStyle == .Action) {
                // perform handler
                animateOut(0.1)
            } else {
                if let selectedIndex = selectedIndex {
                    let oldIndexPath = NSIndexPath(forRow: selectedIndex, inSection: indexPath.section)
                    let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath) as! WTableViewCell
                    oldCell.selectBar.hidden = true
                }
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! WTableViewCell
                cell.selectBar.hidden = false
                selectedIndex = indexPath.row
            }
        } else {
            // selected cancel
            animateOut(0.1)
        }
    }
}

// Table Cell

public class WAction {
    private var title : String?
    private var subtitle : String?
    private var actionStyle : ActionStyle?
    
    public convenience init(title: String) {
        self.init(title: title, subtitle : nil, style: ActionStyle.Normal)
    }
    
    public convenience init(title: String, subtitle: String?) {
        self.init(title: title, subtitle : subtitle, style: ActionStyle.Normal)
    }
    
    public init(title: String, subtitle: String?, style: ActionStyle?) {
        self.title = title
        self.subtitle = subtitle
        self.actionStyle = style
    }
}

public class WTableViewCell : UITableViewCell {
    private var actionInfo : WAction? {
        didSet {
            commonInit()
        }
    }
    
//    public override var highlighted: Bool {
//        didSet {
//            if (highlighted) {
//                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
//                    self.backgroundColor = UIColor.lightGrayColor()
//                    }, completion: nil)
//            } else {
//                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
//                    self.backgroundColor = UIColor.whiteColor()
//                    }, completion: nil)
//            }
//        }
//    }
    
    private var selectBar = UIView(frame: CGRectZero)
    private var separatorBar = UIView(frame: CGRectZero)
    private var subtitleLabel : UILabel?
    private var titleLabel : UILabel?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
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
public class WActionCell : WTableViewCell {
//    public init(title: String, subtitle: String?, style: ActionStyle?, handler: ) {
//        
//    }
}

public class WHeaderView : UITableViewHeaderFooterView {
    private var actionInfo : WAction? {
        didSet {
            commonInit()
        }
    }
    
    private var separatorBar = UIView(frame: CGRectZero)
    private var titleLabel : UILabel?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    public func commonInit() {
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
        
        layoutIfNeeded()
    }
}