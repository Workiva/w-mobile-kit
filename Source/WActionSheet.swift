//
//  WActionSheet.swift
//  Pods

import Foundation
import UIKit
import SnapKit

let CANCEL_SEPARATOR_HEIGHT:CGFloat = 6.0
let ROW_HEIGHT:CGFloat = 50.0
let POPOVER_WIDTH:CGFloat = 450.0

let ACTION_CELL = "actionCell"
let HEADER_VIEW = "headerView"

public enum ActionStyle {
    case Cancel
    case Normal
    case Destructive
}

public class WActionSheetVC<ActionDataType> : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var darkView = UIView(frame: CGRectZero)
    private var containerView = UIView(frame: CGRectZero)
    private var topLine = WTopLine(frame: CGRectZero)
    private var tableView : UITableView?
    private var actions = [Int: Array<WAction<ActionDataType>>]()
    
    public var titleString: String?
    public var selectedIndex : Int?
    public var dismissOnAction = true
    
    public var hasCancel = false {
        didSet {
            if (hasCancel) {
                if (actions[1] == nil) {
                    actions[1] = [WAction<ActionDataType>]()
                }
                
                let cancelAction = WAction<ActionDataType>(title: "Cancel", style: ActionStyle.Cancel)
                actions[1]?.insert(cancelAction, atIndex: 0)
            }
        }
    }
    
    public override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            commonInit()
            preferredContentSize = CGSizeMake(POPOVER_WIDTH, heightForActionSheet())
        }
    }
    
    // Initialization
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            modalPresentationStyle = .Popover
        } else {
            modalPresentationStyle = .OverFullScreen
            modalTransitionStyle = .CrossDissolve
        }
        
        providesPresentationContextTransitionStyle = true
        
        commonInit()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateIn()
    }
    
    public func commonInit() {
        if modalPresentationStyle != .Popover {
            view.addSubview(darkView)
        } else {
            darkView.removeFromSuperview()
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("animateOut"))
        darkView.addGestureRecognizer(recognizer)
        
        view.addSubview(containerView)
        
        tableView = UITableView(frame: CGRectZero)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.delaysContentTouches = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.scrollEnabled = false
        tableView?.allowsMultipleSelection = false
        
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView?.registerClass(WHeaderView.self, forHeaderFooterViewReuseIdentifier: HEADER_VIEW)
        tableView?.registerClass(WTableViewCell<ActionDataType>.self, forCellReuseIdentifier: ACTION_CELL)
        
        containerView.addSubview(tableView!)
        
        containerView.addSubview(topLine)
        containerView.layer.opacity = 0.8
        
        setupUI(false)
    }
    
    public func setupUI(animated: Bool) {
        let height = heightForActionSheet()
        preferredContentSize = CGSizeMake(POPOVER_WIDTH, height)
        
        containerView.snp_remakeConstraints { (make) in
            if (animated) {
                make.top.equalTo(view.snp_bottom)
            } else {
                make.bottom.equalTo(view)
            }
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(height)
        }
        containerView.backgroundColor = UIColor.whiteColor()
        
        if modalPresentationStyle != .Popover {
            darkView.snp_remakeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.top.equalTo(view)
                make.bottom.equalTo(containerView.snp_top)
            }
            darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        }
        
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
        
        view.layoutIfNeeded()
        
        if (animated) {
            containerView.snp_remakeConstraints { (make) in
                make.bottom.equalTo(view)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(height)
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
    
    // Helper Methods
    
    public func heightForActionSheet() -> CGFloat {
        let numCells = actions[0]!.count + (hasCancel ? 1 : 0) + (titleString != nil ? 1 : 0)
        let height = (CGFloat(numCells)) * ROW_HEIGHT + (hasCancel ? CANCEL_SEPARATOR_HEIGHT : 0)
        return height
    }
    
    public func animateIn() {
        if (modalPresentationStyle != .Popover) {
            setupUI(true);
        } else {
            setupUI(false);
        }
    }
    
    public func animateOut() {
        animateOut(0)
    }
    
    public func animateOut(delay: NSTimeInterval = 0) {
        if (modalPresentationStyle != .Popover) {
            containerView.snp_remakeConstraints { (make) in
                make.bottom.equalTo(view).offset(-20)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(heightForActionSheet())
            }

            UIView.animateWithDuration(0.05, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.containerView.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.view.snp_bottom)
                    make.left.equalTo(self.view)
                    make.right.equalTo(self.view)
                }

                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (finished) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Actions
    
    public func addAction(action: WAction<ActionDataType>) {
        if (actions[0] == nil) {
            actions[0] = Array<WAction<ActionDataType>>()
        }
        var actionCopy = action
        actionCopy.index = actions[0]!.count
        actions[0]?.append(actionCopy)
        
        setupUI(false)
        
        tableView?.reloadData()
    }
    
    // Action Selection Methods
    
    public func setSelectedAction(action: WAction<ActionDataType>) {
        setSelectedAction(action.index)
    }
    
    public func setSelectedAction(index: Int) {
        if (index >= actions[0]!.count || index < 0) {
            return
        }
        
        let path = NSIndexPath(forRow: index, inSection: 0)
        let cell = tableView?.cellForRowAtIndexPath(path) as! WTableViewCell<ActionDataType>
        
        cell.selectBar.hidden = false
        selectedIndex = index
    }
    
    public func toggleSelectedAction(action: WAction<ActionDataType>) {
        toggleSelectedAction(action.index)
    }
    
    public func toggleSelectedAction(index: Int) {
        if (index >= actions[0]!.count || index < 0) {
            return
        }
        
        let path = NSIndexPath(forRow: index, inSection: 0)
        let cell = tableView?.cellForRowAtIndexPath(path) as! WTableViewCell<ActionDataType>
        
        cell.selectBar.hidden = !cell.selectBar.hidden
        selectedIndex = cell.selectBar.hidden ? selectedIndex : index
    }
    
    public func deselectAllActions() {
        for action in actions[0]! {
            deselectAction(action.index)
        }
    }
    
    public func deselectAction(index: Int? = nil) {
        var path : NSIndexPath?
        if let index = index {
            if (index > actions[0]?.count) {
                return
            }
            path = NSIndexPath(forRow: index, inSection: 0)
            
        } else if let selectedIndex = selectedIndex {
            path = NSIndexPath(forRow: selectedIndex, inSection: 0)
        } else {
            return
        }
        
        let cell = tableView?.cellForRowAtIndexPath(path!) as! WTableViewCell<ActionDataType>
        cell.selectBar.hidden = true
    }
    
    // Table Support Methods
    
    public func actionForIndexPath(indexPath: NSIndexPath) -> WAction<ActionDataType>? {
        let actionCells = actions[indexPath.section]
        return actionCells![indexPath.row]
    }
    
    // Table Delegate Methods
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section]!.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + (hasCancel ? 1 : 0)
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : WTableViewCell<ActionDataType>
        
        cell = tableView.dequeueReusableCellWithIdentifier(ACTION_CELL) as! WTableViewCell
        
        let action = actionForIndexPath(indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        cell.actionInfo = action
        
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header : UITableViewHeaderFooterView?
        if (section == 0) {
            let WHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HEADER_VIEW) as! WHeaderView
            WHeader.title = titleString
            WHeader.contentView.backgroundColor = UIColor.whiteColor()
            header = WHeader
        } else {
            header = UITableViewHeaderFooterView(frame: CGRectZero)
            header?.contentView.backgroundColor = UIColor(hex: 0xC3C3C3)
        }
        return header!
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return ROW_HEIGHT
        } else {
            return CANCEL_SEPARATOR_HEIGHT
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {            
            // perform handler
            if let action = actionForIndexPath(indexPath) {
                action.handler?(action)
            }
            
            if (dismissOnAction) {
                animateOut(0.1)
            }
        } else {
            // selected cancel
            animateOut(0.1)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

public struct WAction<T> {
    public private(set) var data: T?
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    private var actionStyle : ActionStyle?
    private var handler : (WAction -> Void)?
    public var index = 0
    
    public init(title: String?, subtitle: String? = nil, image: UIImage? = nil, data: T? = nil, style: ActionStyle? = ActionStyle.Normal, handler: (WAction<T> -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.data = data
        self.actionStyle = style
        self.handler = handler
    }
}

// Keyline on top of actionSheet, separate class for theming

public class WTopLine : UIView { }

// Table Cell

// Left bar for selection of actionSheet cells, separate class for theming

public class WSelectBar : UIView { }

public class WTableViewCell<ActionDataType> : UITableViewCell {
    private var actionInfo : WAction<ActionDataType>? {
        didSet {
            commonInit()
        }
    }
    
    private var selectBar = WSelectBar(frame: CGRectZero)
    private var separatorBar = UIView(frame: CGRectZero)
    private var subtitleLabel : UILabel?
    private var titleLabel : UILabel?
    private var iconImageView : UIImageView?
    
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
            contentView.addSubview(selectBar)
        }
        selectBar.snp_removeConstraints()
        selectBar.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(10)
        }
        selectBar.hidden = true
        
        if (!self.subviews.contains(separatorBar)) {
            contentView.addSubview(separatorBar)
        }
        separatorBar.snp_removeConstraints()
        separatorBar.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        separatorBar.backgroundColor = UIColor(hex: 0xC3C3C3)
        
        if let actionInfo = actionInfo {
            if let image = actionInfo.image {
                if iconImageView == nil {
                    iconImageView = UIImageView(image: image)
                    addSubview(iconImageView!)
                }
                
                iconImageView?.snp_removeConstraints()
                iconImageView?.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(self).offset(18)
                    make.centerY.equalTo(self)
                    make.width.equalTo(18)
                    make.height.equalTo(18)
                })
            }
            
            if let subtitle = actionInfo.subtitle {
                if subtitleLabel == nil {
                    subtitleLabel = UILabel(frame: CGRectZero)
                    subtitleLabel?.adjustsFontSizeToFitWidth = true
                    addSubview(subtitleLabel!)
                }
                
                subtitleLabel?.text = subtitle
                subtitleLabel?.font = UIFont.systemFontOfSize(12)
                if (actionInfo.actionStyle == ActionStyle.Destructive) {
                    subtitleLabel?.textColor = UIColor(hex: 0xEE2724)
                } else {
                    subtitleLabel?.textColor = UIColor(hex: 0x707070)
                }
                
                subtitleLabel?.snp_removeConstraints()
                
                subtitleLabel?.snp_makeConstraints(closure: { (make) in
                    if actionInfo.image != nil {
                        make.left.equalTo(iconImageView!.snp_right).offset(18)
                    } else {
                        make.left.equalTo(self).offset(22)
                    }
                    make.right.equalTo(self)
                    make.height.equalTo(14)
                    make.bottom.equalTo(self).offset(-12)
                })
            }
            
            if let title = actionInfo.title {
                if titleLabel == nil {
                    titleLabel = UILabel(frame: CGRectZero)
                    addSubview(titleLabel!)
                }
                
                titleLabel?.text = title
                titleLabel?.font = UIFont.systemFontOfSize(14)
                if (actionInfo.actionStyle == ActionStyle.Cancel) {
                    titleLabel?.textColor = WThemeManager.sharedInstance.currentTheme.actionSheetCancelTextColor
                } else if (actionInfo.actionStyle == ActionStyle.Destructive) {
                    titleLabel?.textColor = UIColor(hex: 0xEE2724)
                } else {
                    titleLabel?.textColor = WThemeManager.sharedInstance.currentTheme.primaryTextColor
                }
                
                titleLabel?.snp_removeConstraints()
                
                titleLabel?.snp_makeConstraints(closure: { (make) in
                    make.height.equalTo(16)
                    
                    if (actionInfo.actionStyle == ActionStyle.Cancel) {
                        make.centerX.equalTo(self)
                    } else {
                        if actionInfo.image != nil {
                            make.left.equalTo(iconImageView!.snp_right).offset(18)
                        } else {
                            make.left.equalTo(self).offset(22)
                        }
                        
                        make.right.equalTo(self)
                    }
                    
                    if actionInfo.subtitle != nil {
                        make.top.equalTo(self).offset(12)
                    } else {
                        make.centerY.equalTo(self)
                    }
                })
            }
        }
        
        layoutIfNeeded()
    }
    
    public override func setSelected(selected: Bool, animated: Bool) {
        let oldSeparatorColor = separatorBar.backgroundColor
        super.setSelected(selected, animated: animated)
        selectBar.backgroundColor = WThemeManager.sharedInstance.currentTheme.actionSheetSelectColor
        separatorBar.backgroundColor = oldSeparatorColor
    }
    
    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        let oldSeparatorColor = separatorBar.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        selectBar.backgroundColor = WThemeManager.sharedInstance.currentTheme.actionSheetSelectColor
        separatorBar.backgroundColor = oldSeparatorColor
    }
}

public class WHeaderView : UITableViewHeaderFooterView {
    private var title : String? {
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
        
        if let title = title {
            if titleLabel == nil {
                titleLabel = UILabel(frame: CGRectZero)
                addSubview(titleLabel!)
            }
            titleLabel?.text = title
            titleLabel?.font = UIFont.systemFontOfSize(16)
            titleLabel?.textColor = UIColor(hex: 0x444444)
            
            titleLabel?.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self).offset(18)
                make.height.equalTo(18)
                make.centerY.equalTo(self)
            })
        }
        
        layoutIfNeeded()
    }
}