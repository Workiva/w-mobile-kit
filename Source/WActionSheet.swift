//
//  WActionSheet.swift
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import UIKit
import SnapKit

let CANCEL_SEPARATOR_HEIGHT: CGFloat = 10.0
let ROW_HEIGHT: CGFloat = 58.0
let CANCEL_HEIGHT: CGFloat = 56.0
let HEADER_HEIGHT: CGFloat = 44.0
let SHEET_WIDTH_IPAD: CGFloat = 355.0

let ACTION_CELL = "actionCell"
let HEADER_VIEW = "headerView"

public enum ActionStyle {
    case Normal, Destructive
}

public enum SheetSeparatorStyle {
    case All, DestructiveOnly
}

internal protocol WBaseActionSheetDelegate: class {
    func commonInit()
    func setupUI(animated: Bool)
    func heightForActionSheet() -> CGFloat
    func setSelectedAction(index: Int)
}

// This view controller manages the status bar for the UIWindow that is created by
//   the properties of the status bar from the view controller presenting it
//   as it is the root view controller of the window
class WActionSheetStatusBarController: UIViewController {
    var previousStatusBarStyle: UIStatusBarStyle?
    var previousStatusBarHidden: Bool?

    override func prefersStatusBarHidden() -> Bool {
        return previousStatusBarHidden == nil ? false : previousStatusBarHidden!
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return previousStatusBarStyle == nil ? .Default : previousStatusBarStyle!
    }
}

public class WBaseActionSheet<ActionDataType>: UIViewController {
    public var presentingWindow: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    public var tapRecognizerView = UIView()
    public var containerView = UIView()
    public var cancelButton = UIButton(type: .System)
    public var actions = [WAction<ActionDataType>]()

    internal weak var delegate: WBaseActionSheetDelegate!

    var statusBarStyleController = WActionSheetStatusBarController()
    var previousStatusBarStyle: UIStatusBarStyle? {
        didSet {
            statusBarStyleController.previousStatusBarStyle = previousStatusBarStyle
        }
    }
    var previousStatusBarHidden: Bool? {
        didSet {
            statusBarStyleController.previousStatusBarHidden = previousStatusBarHidden
        }
    }

    // An optional completion handler to store in case an action is tapped while the action sheet is already dismissing
    var completionToHandle: (() -> Void)?

    public var titleString: String?
    public var selectedIndex: Int?
    public var dismissOnAction = true
    public var hasCancel = false
    public var isDismissing = false

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        checkForPresentingWindow()

        previousStatusBarHidden = UIApplication.sharedApplication().statusBarHidden
        previousStatusBarStyle = UIApplication.sharedApplication().statusBarStyle

        setNeedsStatusBarAppearanceUpdate()
    }

    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        containerView.removeFromSuperview()
        tapRecognizerView.removeFromSuperview()
        cancelButton.removeFromSuperview()

        presentingWindow?.rootViewController = nil
        presentingWindow?.hidden = true
        presentingWindow = nil
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            modalPresentationStyle = .OverCurrentContext
        } else {
            modalPresentationStyle = .OverFullScreen
        }

        modalTransitionStyle = .CrossDissolve

        providesPresentationContextTransitionStyle = true
    }

    // In case an action is tapped during dismissal, still call its completion handler
    public override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        let newCompletion: (() -> Void) = { [weak self] Void in
            completion?()
            self?.completionToHandle?()
        }

        super.dismissViewControllerAnimated(flag, completion: newCompletion)
    }

    public func commonInit() {
        statusBarStyleController.view.userInteractionEnabled = false

        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)

        presentingWindow?.windowLevel = UIWindowLevelStatusBar + 1
        presentingWindow?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        presentingWindow?.rootViewController = statusBarStyleController
        presentingWindow?.hidden = true

        presentingWindow?.addSubview(tapRecognizerView)

        let animateOutSelector = #selector(animateOut as Void -> Void)
        if (tapRecognizerView.gestureRecognizers == nil) {
            // Do not use #selector here, causes issue with iPhone 4S
            let darkViewRecognizer = UITapGestureRecognizer(target: self, action: animateOutSelector)
            tapRecognizerView.addGestureRecognizer(darkViewRecognizer)
        }

        cancelButton.addTarget(self, action: animateOutSelector, forControlEvents: .TouchUpInside)
        cancelButton.tintColor = .lightGrayColor()

        presentingWindow?.addSubview(containerView)
        presentingWindow?.addSubview(cancelButton)
    }

    public func setupUI(animated: Bool) {
        checkForPresentingWindow()

        let height = delegate.heightForActionSheet()
        preferredContentSize = CGSizeMake(SHEET_WIDTH_IPAD, height)

        containerView.snp_remakeConstraints { (make) in
            if (animated) {
                make.top.equalTo(presentingWindow!.snp_bottom)
            } else {
                if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                    make.centerY.equalTo(presentingWindow!)
                } else {
                    make.bottom.equalTo(presentingWindow!).offset(-10)
                }
            }
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                make.width.equalTo(SHEET_WIDTH_IPAD)
                make.centerX.equalTo(presentingWindow!)
            } else {
                make.left.equalTo(presentingWindow!).offset(10)
                make.right.equalTo(presentingWindow!).offset(-10)
            }
            make.height.equalTo(height)
        }
        containerView.backgroundColor = .clearColor()

        if (hasCancel) {
            cancelButton.snp_remakeConstraints { (make) in
                make.left.equalTo(containerView)
                make.right.equalTo(containerView)
                make.height.equalTo(CANCEL_HEIGHT)
                make.bottom.equalTo(containerView)
            }

            cancelButton.setTitle("Cancel", forState: .Normal)
            cancelButton.setTitleColor(UIColor(hex: 0x595959), forState: .Normal)
            cancelButton.titleLabel?.font = UIFont.systemFontOfSize(20)
            cancelButton.backgroundColor = .whiteColor()
            cancelButton.layer.cornerRadius = 4
            cancelButton.clipsToBounds = true
        }

        tapRecognizerView.snp_remakeConstraints { (make) in
            make.left.equalTo(presentingWindow!)
            make.right.equalTo(presentingWindow!)
            make.top.equalTo(presentingWindow!)
            make.bottom.equalTo(presentingWindow!)
        }
        tapRecognizerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(animated ? 0.0 : 0.4)
    }

    // MARK: - Helper Methods
    public func animateIn() {
        delegate?.setupUI(true)
        presentingWindow?.hidden = false
    }

    public func animateOut() {
        animateOut(0.1)
    }

    public func animateOut(delay: NSTimeInterval, completion: (() -> Void)? = nil) {
        checkForPresentingWindow()

        // Do not dismiss twice, but store the completion handler to be called if needed
        if (isDismissing) {
            if (completion != nil) {
                completionToHandle = completion
            }

            return
        }

        isDismissing = true

        containerView.snp_remakeConstraints { (make) in
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                make.centerX.equalTo(presentingWindow!)
                make.centerY.equalTo(presentingWindow!).offset(-10)
                make.width.equalTo(SHEET_WIDTH_IPAD)
            } else {
                make.bottom.equalTo(presentingWindow!).offset(-20)
                make.left.equalTo(presentingWindow!).offset(10)
                make.right.equalTo(presentingWindow!).offset(-10)
            }
            make.height.equalTo((delegate?.heightForActionSheet())!)
        }

        UIView.animateWithDuration(0.05, delay: delay, options: UIViewAnimationOptions.CurveEaseOut,
            animations: { [weak self] in
                self?.presentingWindow?.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                if self != nil {
                    self!.containerView.snp_remakeConstraints { (make) in
                        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                            make.width.equalTo(SHEET_WIDTH_IPAD)
                            make.centerX.equalTo(self!.presentingWindow!)
                        } else {
                            make.left.equalTo(self!.presentingWindow!).offset(10)
                            make.right.equalTo(self!.presentingWindow!).offset(-10)
                        }
                        make.height.equalTo((self!.delegate?.heightForActionSheet())!)
                        make.top.equalTo(self!.presentingWindow!.snp_bottom)
                    }

                    UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { [weak self] in
                            self?.presentingWindow?.layoutIfNeeded()
                            self?.tapRecognizerView.backgroundColor = .clearColor()
                        },
                        completion: { [weak self] finished in
                            self?.dismissViewControllerAnimated(false, completion: completion)
                            self?.isDismissing = false
                        }
                    )
                }
            }
        )
    }

    // MARK: - Actions
    public func addAction(action: WAction<ActionDataType>) {
        let actionCopy = action
        actionCopy.index = actions.count
        actions.append(actionCopy)

        delegate?.setupUI(false)
    }

    public func actionForIndexPath(indexPath: NSIndexPath) -> WAction<ActionDataType> {
        return actions[indexPath.row]
    }

    public func actionForIndex(index: Int) -> WAction<ActionDataType> {
        return actions[index]
    }

    public func setSelectedAction(action: WAction<ActionDataType>) {
        delegate?.setSelectedAction(action.index)
    }

    func checkForPresentingWindow() {
        if (presentingWindow == nil) {
            presentingWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            commonInit()
        }
    }
}

public class WAction<T> {
    public private(set) var data: T?
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    public var actionStyle: ActionStyle?
    public var handler: (WAction -> Void)?
    public var index = 0
    public var enabled = true

    public init(title: String?,
                subtitle: String? = nil,
                image: UIImage? = nil,
                data: T? = nil,
                style: ActionStyle? = ActionStyle.Normal,
                enabled: Bool = true,
                handler: (WAction<T> -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.data = data
        self.actionStyle = style
        self.enabled = enabled
        self.handler = handler
    }
}

// MARK: - Table Action Sheet
public class WActionSheetVC<ActionDataType>: WBaseActionSheet<ActionDataType>, WBaseActionSheetDelegate, UITableViewDelegate, UITableViewDataSource {
    internal var tableView = UITableView()
    public var executeActionAfterDismissal = false

    public var sheetSeparatorStyle = SheetSeparatorStyle.DestructiveOnly {
        didSet {
            tableView.reloadData()
        }
    }

    public func defaultMaxSheetHeight() -> CGFloat {
        // 80% of screen height
        return UIScreen.mainScreen().bounds.size.height * 0.8
    }

    public var maxSheetHeight: CGFloat? {
        didSet {
            setupUI(false)
        }
    }

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        animateIn()
    }

    public override func commonInit() {
        super.commonInit()

        delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.scrollEnabled = true
        tableView.bounces = false
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .None

        tableView.registerClass(WHeaderView.self, forHeaderFooterViewReuseIdentifier: HEADER_VIEW)
        tableView.registerClass(WTableViewCell<ActionDataType>.self, forCellReuseIdentifier: ACTION_CELL)

        containerView.addSubview(tableView)

        setupUI(false)
    }

    public override func setupUI(animated: Bool) {
        super.setupUI(animated)

        tableView.reloadData()

        let height = heightForActionSheet()

        tableView.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
            if (hasCancel) {
                make.bottom.equalTo(cancelButton.snp_top).offset(-CANCEL_SEPARATOR_HEIGHT)
            } else {
                make.bottom.equalTo(containerView)
            }
        }

        tableView.layer.cornerRadius = 4
        tableView.clipsToBounds = true
        tableView.contentSize = CGSize(width: tableView.contentSize.width, height: heightForSheetContent())
        if (titleString != nil) {
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        }

        presentingWindow?.layoutIfNeeded()

        if (animated) {
            containerView.snp_remakeConstraints { (make) in
                if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                    make.centerY.equalTo(presentingWindow!)
                    make.centerX.equalTo(presentingWindow!)
                    make.width.equalTo(SHEET_WIDTH_IPAD)
                } else {
                    make.bottom.equalTo(presentingWindow!).offset(-10)
                    make.left.equalTo(presentingWindow!).offset(10)
                    make.right.equalTo(presentingWindow!).offset(-10)
                }
                make.height.equalTo(height)
            }

            UIView.animateWithDuration(0.35, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.presentingWindow?.layoutIfNeeded()
                    self.tapRecognizerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
                },
                completion: nil
            )
        }
    }

    // MARK: - Helper Methods
    public func heightForActionSheet() -> CGFloat {
        let numCells = actions.count
        let height = ((CGFloat(numCells)) * ROW_HEIGHT) + (hasCancel ? (CANCEL_SEPARATOR_HEIGHT + CANCEL_HEIGHT) : 0) + (titleString != nil ? HEADER_HEIGHT : 0)
        let maxHeight = (maxSheetHeight != nil) ? maxSheetHeight! : defaultMaxSheetHeight()

        return min(height, maxHeight)
    }

    public func heightForSheetContent() -> CGFloat {
        let numCells = actions.count
        let height = ((CGFloat(numCells)) * ROW_HEIGHT) + (titleString != nil ? HEADER_HEIGHT : 0)
        return height
    }

    // MARK: Action Selection Methods
    public func setSelectedAction(index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }

        let path = NSIndexPath(forRow: index, inSection: 0)

        // Cell may not be visible yet.
        if let cell = tableView.cellForRowAtIndexPath(path) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(true)
        }
        selectedIndex = index
    }

    public func toggleSelectedAction(action: WAction<ActionDataType>) {
        toggleSelectedAction(action.index)
    }

    public func toggleSelectedAction(index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }

        let path = NSIndexPath(forRow: index, inSection: 0)

        // Cell may not be visible yet.
        if let cell = tableView.cellForRowAtIndexPath(path) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(!cell.isSelectedAction)
            selectedIndex = cell.selectBar.hidden ? selectedIndex : index
        }
    }

    public func deselectAllActions() {
        for action in actions {
            deselectAction(action.index)
        }
    }

    public func deselectAction(index: Int? = nil) {
        var path: NSIndexPath?
        if let index = index {
            if (index > actions.count) {
                return
            }
            path = NSIndexPath(forRow: index, inSection: 0)
        } else if let selectedIndex = selectedIndex {
            path = NSIndexPath(forRow: selectedIndex, inSection: 0)
        } else {
            return
        }

        // The selected cell may no longer be visible / in memory
        if let cell = tableView.cellForRowAtIndexPath(path!) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(false)
        }
    }

    // MARK: - UITableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return actions.count
        }

        return 0
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ROW_HEIGHT
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: WTableViewCell<ActionDataType>

        cell = tableView.dequeueReusableCellWithIdentifier(ACTION_CELL) as! WTableViewCell

        let action = actionForIndexPath(indexPath)
        cell.backgroundColor = .whiteColor()
        cell.actionInfo = action

        cell.separatorBar.hidden = !((sheetSeparatorStyle == .All && indexPath.row != 0)
            || (sheetSeparatorStyle == .DestructiveOnly && action.actionStyle == ActionStyle.Destructive))

        if (indexPath.row == selectedIndex) {
            cell.setSelectedAction(true)
        }

        return cell
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let WHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HEADER_VIEW) as! WHeaderView
        WHeader.title = titleString
        WHeader.contentView.backgroundColor = UIColor(hex: 0xF3F3F3)

        return WHeader
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return titleString != nil ? HEADER_HEIGHT : 0
    }

    // MARK: - UITableViewDelegate
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            // perform handler
            if let action: WAction<ActionDataType> = actionForIndexPath(indexPath) {
                weak var weakAction = action

                if (executeActionAfterDismissal) {
                    animateOut(0.1, completion: {
                        action.handler?(weakAction!)
                    })

                    return
                }

                action.handler?(weakAction!)
            }

            if (dismissOnAction) {
                animateOut(0.1)
            }
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0) {
            let action = actionForIndexPath(indexPath)

            return action.enabled
        }

        return true
    }
}

// MARK: - Table Cell
public class WTableViewCell<ActionDataType>: UITableViewCell {
    private weak var actionInfo: WAction<ActionDataType>? {
        didSet {
            commonInit()
        }
    }

    var selectBar = WSelectBar()
    internal var subtitleLabel: UILabel?
    internal var titleLabel: UILabel?
    internal var iconImageView: UIImageView?
    internal var disabledView = UIView()
    public private(set) var separatorBar = UIView()
    public private(set) var isSelectedAction = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    public func commonInit() {
        if (!subviews.contains(selectBar)) {
            contentView.addSubview(selectBar)
        }
        selectBar.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(3)
        }
        selectBar.hidden = true

        if (!subviews.contains(separatorBar)) {
            contentView.addSubview(separatorBar)
        }
        separatorBar.snp_removeConstraints()
        separatorBar.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        separatorBar.backgroundColor = UIColor(hex: 0xDADADE)

        if let actionInfo = actionInfo {
            if let image = actionInfo.image {
                if (iconImageView == nil) {
                    iconImageView = UIImageView(image: image)
                    addSubview(iconImageView!)
                }

                iconImageView?.snp_remakeConstraints(closure: { (make) in
                    make.left.equalTo(self).offset(14)
                    make.centerY.equalTo(self)
                    make.width.equalTo(25)
                    make.height.equalTo(25)
                })
            } else {
                iconImageView?.image = nil
            }

            if let subtitle = actionInfo.subtitle {
                if (subtitleLabel == nil) {
                    subtitleLabel = UILabel()
                    subtitleLabel?.adjustsFontSizeToFitWidth = true
                    addSubview(subtitleLabel!)
                }

                subtitleLabel?.text = subtitle
                subtitleLabel?.font = UIFont.systemFontOfSize(12)
                subtitleLabel?.textColor = UIColor(hex: 0x707070)

                subtitleLabel?.snp_remakeConstraints(closure: { (make) in
                    if (actionInfo.image != nil) {
                        make.left.equalTo(iconImageView!.snp_right).offset(16)
                    } else {
                        make.left.equalTo(self).offset(22)
                    }
                    make.right.equalTo(self)
                    make.height.equalTo(14)
                    make.bottom.equalTo(self).offset(-8)
                })
            } else {
                subtitleLabel?.text = ""
            }

            if let title = actionInfo.title {
                if (titleLabel == nil) {
                    titleLabel = UILabel()
                    addSubview(titleLabel!)
                }

                titleLabel?.text = title
                titleLabel?.font = UIFont.systemFontOfSize(20)
                titleLabel?.textColor = UIColor(hex: 0x595959)

                titleLabel?.snp_remakeConstraints(closure: { (make) in
                    make.height.equalTo(23)

                    if (actionInfo.image != nil) {
                        make.left.equalTo(iconImageView!.snp_right).offset(16)
                    } else {
                        make.left.equalTo(self).offset(22)
                    }

                    make.right.equalTo(self)

                    if (actionInfo.subtitle != nil) {
                        make.top.equalTo(self).offset(8)
                    } else {
                        make.centerY.equalTo(self)
                    }
                })
            } else {
                titleLabel?.text = ""
            }

            if (!actionInfo.enabled) {
                addSubview(disabledView)
                disabledView.hidden = false
                disabledView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

                disabledView.snp_remakeConstraints { (make) in
                    make.top.equalTo(self).offset(0.5)
                    make.bottom.equalTo(self)
                    make.left.equalTo(self)
                    make.right.equalTo(self)
                }
            } else {
                disabledView.hidden = true
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

    public func setSelectedAction(selected: Bool) {
        selectBar.hidden = !selected

        if let titleLabel = titleLabel {
            titleLabel.font = selected ? UIFont.boldSystemFontOfSize(titleLabel.font.pointSize) : UIFont.systemFontOfSize(titleLabel.font.pointSize)
        }

        if let subtitleLabel = subtitleLabel {
            subtitleLabel.font = selected ? UIFont.boldSystemFontOfSize(subtitleLabel.font.pointSize) : UIFont.systemFontOfSize(subtitleLabel.font.pointSize)
        }

        isSelectedAction = selected
    }
}

// MARK: Header View
public class WHeaderView: UITableViewHeaderFooterView {
    private var title: String? {
        didSet {
            commonInit()
        }
    }

    private var separatorBar = UIView()
    private var titleLabel: UILabel?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        commonInit()
    }
    public func commonInit() {
        if (!subviews.contains(separatorBar)) {
            addSubview(separatorBar)
        }
        separatorBar.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        separatorBar.backgroundColor = UIColor(hex: 0xDADADE)

        if let title = title {
            if (titleLabel == nil) {
                titleLabel = UILabel()
                addSubview(titleLabel!)
            }
            titleLabel?.textAlignment = .Center
            titleLabel?.text = title
            titleLabel?.font = UIFont.systemFontOfSize(15)
            titleLabel?.textColor = UIColor(hex: 0x595959)

            titleLabel?.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(18)
                make.centerY.equalTo(self)
            })
        }

        layoutIfNeeded()
    }
}

// MARK: Select Bar
public class WSelectBar: UIView { }

// MARK: - PickerView Action Sheet
public protocol WPickerActionSheetDelegate: class {
    func pickerViewDoneButtonWasTapped(selectedIndex: Int)
    func pickerViewCancelButtonWasTapped()
}

public class WPickerActionSheet<ActionDataType>: WBaseActionSheet<ActionDataType>, WBaseActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    internal var toolbarDoneButton = UIButton()
    internal var toolbarCancelButton = UIButton()
    internal var toolbarContainerView = UIView()
    internal var pickerView: UIPickerView = UIPickerView()
    internal let PICKER_VIEW_HEIGHT: CGFloat = 258.0
    public weak var pickerDelegate: WPickerActionSheetDelegate?

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        animateIn()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let toolbarRoundedCornerRect = CAShapeLayer()
        toolbarRoundedCornerRect.bounds = toolbarContainerView.frame
        toolbarRoundedCornerRect.position = toolbarContainerView.center
        toolbarRoundedCornerRect.path = UIBezierPath(roundedRect: toolbarContainerView.bounds, byRoundingCorners: UIRectCorner.TopLeft.union(.TopRight), cornerRadii: CGSize(width: 5, height: 5)).CGPath

        toolbarContainerView.layer.masksToBounds = true
        toolbarContainerView.layer.mask = toolbarRoundedCornerRect

        let pickerRoundedCornerRect = CAShapeLayer()
        pickerRoundedCornerRect.bounds = pickerView.frame
        pickerRoundedCornerRect.position = pickerView.center
        pickerRoundedCornerRect.path = UIBezierPath(roundedRect: pickerView.bounds, byRoundingCorners: UIRectCorner.BottomLeft.union(.BottomRight), cornerRadii: CGSize(width: 5, height: 5)).CGPath

        pickerView.layer.masksToBounds = true
        pickerView.layer.mask = pickerRoundedCornerRect
    }

    public override func commonInit() {
        super.commonInit()

        delegate = self

        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self

        toolbarCancelButton.setTitle("Cancel", forState: .Normal)
        toolbarCancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        toolbarCancelButton.addTarget(self, action: #selector(WPickerActionSheet.toolbarCancelButtonWasTouched), forControlEvents: .TouchUpInside)

        toolbarDoneButton.setTitle("Done", forState: .Normal)
        toolbarDoneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        toolbarDoneButton.addTarget(self, action: #selector(WPickerActionSheet.toolbarDoneButtonWasTouched), forControlEvents: .TouchUpInside)

        toolbarContainerView.addSubview(toolbarCancelButton)
        toolbarContainerView.addSubview(toolbarDoneButton)
        toolbarContainerView.backgroundColor = .whiteColor()

        containerView.addSubview(toolbarContainerView)
        containerView.addSubview(pickerView)

        setupUI(false)
    }

    public override func setupUI(animated: Bool) {
        super.setupUI(animated)

        pickerView.reloadAllComponents()

        let height = heightForActionSheet()

        toolbarContainerView.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
        }

        toolbarCancelButton.snp_remakeConstraints { (make) in
            make.left.equalTo(toolbarContainerView).offset(20)
            make.bottom.equalTo(toolbarContainerView).offset(-2)
        }

        toolbarDoneButton.snp_remakeConstraints { (make) in
            make.right.equalTo(toolbarContainerView).offset(-20)
            make.bottom.equalTo(toolbarContainerView).offset(-2)
        }

        pickerView.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(toolbarContainerView.snp_bottom)
            make.bottom.equalTo(containerView.snp_bottom)
        }

        view.layoutIfNeeded()

        if (animated) {
            containerView.snp_remakeConstraints { (make) in
                if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                    make.centerY.equalTo(presentingWindow!)
                    make.centerX.equalTo(presentingWindow!)
                    make.width.equalTo(SHEET_WIDTH_IPAD)
                } else {
                    make.bottom.equalTo(presentingWindow!).offset(-10)
                    make.left.equalTo(presentingWindow!).offset(10)
                    make.right.equalTo(presentingWindow!).offset(-10)
                }
                make.height.equalTo(height)
            }

            UIView.animateWithDuration(0.35, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: { [weak self] in
                    self?.presentingWindow?.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func toolbarDoneButtonWasTouched(){
        animateOut()
        pickerDelegate?.pickerViewDoneButtonWasTapped(pickerView.selectedRowInComponent(0))
    }

    func toolbarCancelButtonWasTouched(){
        animateOut()
        pickerDelegate?.pickerViewCancelButtonWasTapped()
    }

    public func setSelectedAction(index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }

    public func heightForActionSheet() -> CGFloat {
        if (actions.count == 0) {
            return CGFloat(0)
        }
        return CGFloat(PICKER_VIEW_HEIGHT)
    }

    // MARK: - UIPickerView Delegate
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actions.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return actions[row].title! as String
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let action: WAction<ActionDataType> = actionForIndex(row) {
            action.handler?(action)
        }
    }
}
