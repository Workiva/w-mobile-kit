//
//  WActionSheet.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
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
    case normal, destructive
}

public enum SheetSeparatorStyle {
    case all, destructiveOnly
}

internal protocol WBaseActionSheetDelegate: class {
    func commonInit()
    func setupUI(_ animated: Bool)
    func heightForActionSheet() -> CGFloat
    func setSelectedAction(_ index: Int)
}

// This view controller manages the status bar for the UIWindow that is created by
//   the properties of the status bar from the view controller presenting it
//   as it is the root view controller of the window
class WActionSheetStatusBarController: UIViewController {
    var previousStatusBarStyle: UIStatusBarStyle?
    var previousStatusBarHidden: Bool?

    override var prefersStatusBarHidden : Bool {
        return previousStatusBarHidden == nil ? false : previousStatusBarHidden!
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return previousStatusBarStyle == nil ? .default : previousStatusBarStyle!
    }
}

open class WBaseActionSheet<ActionDataType>: UIViewController {
    open var presentingWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    open var tapRecognizerView = UIView()
    open var containerView = UIView()
    open var cancelButton = UIButton(type: .system)
    open var actions = [WAction<ActionDataType>]()

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

    open var titleString: String?
    open var selectedIndex: Int?
    open var dismissOnAction = true
    open var hasCancel = false
    open var isDismissing = false

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkForPresentingWindow()

        previousStatusBarHidden = UIApplication.shared.isStatusBarHidden
        previousStatusBarStyle = UIApplication.shared.statusBarStyle

        setNeedsStatusBarAppearanceUpdate()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        containerView.removeFromSuperview()
        tapRecognizerView.removeFromSuperview()
        cancelButton.removeFromSuperview()

        presentingWindow?.rootViewController = nil
        presentingWindow?.isHidden = true
        presentingWindow = nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            modalPresentationStyle = .overCurrentContext
        } else {
            modalPresentationStyle = .overFullScreen
        }

        modalTransitionStyle = .crossDissolve

        providesPresentationContextTransitionStyle = true
    }

    // In case an action is tapped during dismissal, still call its completion handler
    open override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        let newCompletion: (() -> Void) = { [weak self] Void in
            completion?()
            self?.completionToHandle?()
        }

        super.dismiss(animated: flag, completion: newCompletion)
    }

    open func commonInit() {
        statusBarStyleController.view.isUserInteractionEnabled = false

        view.backgroundColor = UIColor.white.withAlphaComponent(0.0)

        presentingWindow?.windowLevel = UIWindowLevelStatusBar + 1
        presentingWindow?.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        presentingWindow?.rootViewController = statusBarStyleController
        presentingWindow?.isHidden = true

        presentingWindow?.addSubview(tapRecognizerView)

        let animateOutSelector = #selector(animateOut as (Void) -> Void)
        if (tapRecognizerView.gestureRecognizers == nil) {
            // Do not use #selector here, causes issue with iPhone 4S
            let darkViewRecognizer = UITapGestureRecognizer(target: self, action: animateOutSelector)
            tapRecognizerView.addGestureRecognizer(darkViewRecognizer)
        }

        cancelButton.addTarget(self, action: animateOutSelector, for: .touchUpInside)
        cancelButton.tintColor = .lightGray

        presentingWindow?.addSubview(containerView)
        presentingWindow?.addSubview(cancelButton)
    }

    open func setupUI(_ animated: Bool) {
        checkForPresentingWindow()

        let height = delegate.heightForActionSheet()
        preferredContentSize = CGSize(width: SHEET_WIDTH_IPAD, height: height)

        containerView.snp.remakeConstraints { (make) in
            if (animated) {
                make.top.equalTo(presentingWindow!.snp.bottom)
            } else {
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    make.centerY.equalTo(presentingWindow!)
                } else {
                    make.bottom.equalTo(presentingWindow!).offset(-10)
                }
            }
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                make.width.equalTo(SHEET_WIDTH_IPAD)
                make.centerX.equalTo(presentingWindow!)
            } else {
                make.left.equalTo(presentingWindow!).offset(10)
                make.right.equalTo(presentingWindow!).offset(-10)
            }
            make.height.equalTo(height)
        }
        containerView.backgroundColor = .clear

        if (hasCancel) {
            cancelButton.snp.remakeConstraints { (make) in
                make.left.equalTo(containerView)
                make.right.equalTo(containerView)
                make.height.equalTo(CANCEL_HEIGHT)
                make.bottom.equalTo(containerView)
            }

            cancelButton.setTitle("Cancel", for: UIControlState())
            cancelButton.setTitleColor(UIColor(hex: 0x595959), for: UIControlState())
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            cancelButton.backgroundColor = .white
            cancelButton.layer.cornerRadius = 4
            cancelButton.clipsToBounds = true
        }

        tapRecognizerView.snp.remakeConstraints { (make) in
            make.left.equalTo(presentingWindow!)
            make.right.equalTo(presentingWindow!)
            make.top.equalTo(presentingWindow!)
            make.bottom.equalTo(presentingWindow!)
        }
        tapRecognizerView.backgroundColor = UIColor.black.withAlphaComponent(animated ? 0.0 : 0.4)
    }

    // MARK: - Helper Methods
    open func animateIn() {
        delegate?.setupUI(true)
        presentingWindow?.isHidden = false
    }

    open func animateOut() {
        animateOut(0.1)
    }

    open func animateOut(_ delay: TimeInterval, completion: (() -> Void)? = nil) {
        checkForPresentingWindow()

        // Do not dismiss twice, but store the completion handler to be called if needed
        if (isDismissing) {
            if (completion != nil) {
                completionToHandle = completion
            }

            return
        }

        isDismissing = true

        containerView.snp.remakeConstraints { (make) in
            if (UIDevice.current.userInterfaceIdiom == .pad) {
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

        UIView.animate(withDuration: 0.05, delay: delay, options: UIViewAnimationOptions.curveEaseOut,
            animations: { [weak self] in
                self?.presentingWindow?.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                if self != nil {
                    self!.containerView.snp.remakeConstraints { (make) in
                        if (UIDevice.current.userInterfaceIdiom == .pad) {
                            make.width.equalTo(SHEET_WIDTH_IPAD)
                            make.centerX.equalTo(self!.presentingWindow!)
                        } else {
                            make.left.equalTo(self!.presentingWindow!).offset(10)
                            make.right.equalTo(self!.presentingWindow!).offset(-10)
                        }
                        make.height.equalTo((self!.delegate?.heightForActionSheet())!)
                        make.top.equalTo(self!.presentingWindow!.snp.bottom)
                    }

                    UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(),
                        animations: { [weak self] in
                            self?.presentingWindow?.layoutIfNeeded()
                            self?.tapRecognizerView.backgroundColor = .clear
                        },
                        completion: { [weak self] finished in
                            self?.dismiss(animated: false, completion: completion)
                            self?.isDismissing = false
                        }
                    )
                }
            }
        )
    }

    // MARK: - Actions
    open func addAction(_ action: WAction<ActionDataType>) {
        let actionCopy = action
        actionCopy.index = actions.count
        actions.append(actionCopy)

        delegate?.setupUI(false)
    }

    open func actionForIndexPath(_ indexPath: IndexPath) -> WAction<ActionDataType> {
        return actions[(indexPath as NSIndexPath).row]
    }

    open func actionForIndex(_ index: Int) -> WAction<ActionDataType> {
        return actions[index]
    }

    open func setSelectedAction(_ action: WAction<ActionDataType>) {
        delegate?.setSelectedAction(action.index)
    }

    func checkForPresentingWindow() {
        if (presentingWindow == nil) {
            presentingWindow = UIWindow(frame: UIScreen.main.bounds)
            commonInit()
        }
    }
}

open class WAction<T> {
    open fileprivate(set) var data: T?
    open var title: String?
    open var subtitle: String?
    open var image: UIImage?
    open var actionStyle: ActionStyle?
    open var handler: ((WAction) -> Void)?
    open var index = 0
    open var enabled = true

    public init(title: String?,
                subtitle: String? = nil,
                image: UIImage? = nil,
                data: T? = nil,
                style: ActionStyle? = ActionStyle.normal,
                enabled: Bool = true,
                handler: ((WAction<T>) -> Void)? = nil) {
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
open class WActionSheetVC<ActionDataType>: WBaseActionSheet<ActionDataType>, WBaseActionSheetDelegate, UITableViewDelegate, UITableViewDataSource {
    internal var tableView = UITableView()
    open var executeActionAfterDismissal = false

    open var sheetSeparatorStyle = SheetSeparatorStyle.destructiveOnly {
        didSet {
            tableView.reloadData()
        }
    }

    open func defaultMaxSheetHeight() -> CGFloat {
        // 80% of screen height
        return UIScreen.main.bounds.size.height * 0.8
    }

    open var maxSheetHeight: CGFloat? {
        didSet {
            setupUI(false)
        }
    }

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateIn()
    }

    open override func commonInit() {
        super.commonInit()

        delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.bounces = false
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none

        tableView.register(WHeaderView.self, forHeaderFooterViewReuseIdentifier: HEADER_VIEW)
        tableView.register(WTableViewCell<ActionDataType>.self, forCellReuseIdentifier: ACTION_CELL)

        containerView.addSubview(tableView)

        setupUI(false)
    }

    open override func setupUI(_ animated: Bool) {
        super.setupUI(animated)

        tableView.reloadData()

        let height = heightForActionSheet()

        tableView.snp.remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
            if (hasCancel) {
                make.bottom.equalTo(cancelButton.snp.top).offset(-CANCEL_SEPARATOR_HEIGHT)
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
            containerView.snp.remakeConstraints { (make) in
                if (UIDevice.current.userInterfaceIdiom == .pad) {
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

            UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    self.presentingWindow?.layoutIfNeeded()
                    self.tapRecognizerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                },
                completion: nil
            )
        }
    }

    // MARK: - Helper Methods
    open func heightForActionSheet() -> CGFloat {
        let numCells = actions.count
        let height = ((CGFloat(numCells)) * ROW_HEIGHT) + (hasCancel ? (CANCEL_SEPARATOR_HEIGHT + CANCEL_HEIGHT) : 0) + (titleString != nil ? HEADER_HEIGHT : 0)
        let maxHeight = (maxSheetHeight != nil) ? maxSheetHeight! : defaultMaxSheetHeight()

        return min(height, maxHeight)
    }

    open func heightForSheetContent() -> CGFloat {
        let numCells = actions.count
        let height = ((CGFloat(numCells)) * ROW_HEIGHT) + (titleString != nil ? HEADER_HEIGHT : 0)
        return height
    }

    // MARK: Action Selection Methods
    open func setSelectedAction(_ index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }

        let path = IndexPath(row: index, section: 0)

        // Cell may not be visible yet.
        if let cell = tableView.cellForRow(at: path) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(true)
        }
        selectedIndex = index
    }

    open func toggleSelectedAction(_ action: WAction<ActionDataType>) {
        toggleSelectedAction(action.index)
    }

    open func toggleSelectedAction(_ index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }

        let path = IndexPath(row: index, section: 0)

        // Cell may not be visible yet.
        if let cell = tableView.cellForRow(at: path) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(!cell.isSelectedAction)
            selectedIndex = cell.selectBar.isHidden ? selectedIndex : index
        }
    }

    open func deselectAllActions() {
        for action in actions {
            deselectAction(action.index)
        }
    }

    open func deselectAction(_ index: Int? = nil) {
        var path: IndexPath?
        if let index = index {
            if (index > actions.count) {
                return
            }
            path = IndexPath(row: index, section: 0)
        } else if let selectedIndex = selectedIndex {
            path = IndexPath(row: selectedIndex, section: 0)
        } else {
            return
        }

        // The selected cell may no longer be visible / in memory
        if let cell = tableView.cellForRow(at: path!) as? WTableViewCell<ActionDataType> {
            cell.setSelectedAction(false)
        }
    }

    // MARK: - UITableViewDataSource
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return actions.count
        }

        return 0
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ROW_HEIGHT
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WTableViewCell<ActionDataType>

        cell = tableView.dequeueReusableCell(withIdentifier: ACTION_CELL) as! WTableViewCell

        let action = actionForIndexPath(indexPath)
        cell.backgroundColor = .white
        cell.actionInfo = action

        cell.separatorBar.isHidden = !((sheetSeparatorStyle == .all && (indexPath as NSIndexPath).row != 0)
            || (sheetSeparatorStyle == .destructiveOnly && action.actionStyle == ActionStyle.destructive))

        if ((indexPath as NSIndexPath).row == selectedIndex) {
            cell.setSelectedAction(true)
        }

        return cell
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let WHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_VIEW) as! WHeaderView
        WHeader.title = titleString
        WHeader.contentView.backgroundColor = UIColor(hex: 0xF3F3F3)

        return WHeader
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return titleString != nil ? HEADER_HEIGHT : 0
    }

    // MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).section == 0) {
            // perform handler
            let action: WAction<ActionDataType> = actionForIndexPath(indexPath)

            weak var weakAction = action

            if (executeActionAfterDismissal) {
                animateOut(0.1, completion: {
                    action.handler?(weakAction!)
                })

                return
            }

            action.handler?(weakAction!)


            if (dismissOnAction) {
                animateOut(0.1)
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if ((indexPath as NSIndexPath).section == 0) {
            let action = actionForIndexPath(indexPath)

            return action.enabled
        }

        return true
    }
}

// MARK: - Table Cell
open class WTableViewCell<ActionDataType>: UITableViewCell {
    fileprivate weak var actionInfo: WAction<ActionDataType>? {
        didSet {
            commonInit()
        }
    }

    var selectBar = WSelectBar()
    internal var subtitleLabel: UILabel?
    internal var titleLabel: UILabel?
    internal var iconImageView: UIImageView?
    internal var disabledView = UIView()
    open fileprivate(set) var separatorBar = UIView()
    open fileprivate(set) var isSelectedAction = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    open func commonInit() {
        if (!subviews.contains(selectBar)) {
            contentView.addSubview(selectBar)
        }
        selectBar.snp.remakeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(3)
        }
        selectBar.isHidden = true

        if (!subviews.contains(separatorBar)) {
            contentView.addSubview(separatorBar)
        }
        separatorBar.snp.removeConstraints()
        separatorBar.snp.makeConstraints { (make) in
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

                iconImageView?.snp.remakeConstraints { (make) in
                    make.left.equalTo(self).offset(14)
                    make.centerY.equalTo(self)
                    make.width.equalTo(25)
                    make.height.equalTo(25)
                }
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
                subtitleLabel?.font = UIFont.systemFont(ofSize: 12)
                subtitleLabel?.textColor = UIColor(hex: 0x707070)

                subtitleLabel?.snp.remakeConstraints { (make) in
                    if (actionInfo.image != nil) {
                        make.left.equalTo(iconImageView!.snp.right).offset(16)
                    } else {
                        make.left.equalTo(self).offset(22)
                    }
                    make.right.equalTo(self)
                    make.height.equalTo(14)
                    make.bottom.equalTo(self).offset(-8)
                }
            } else {
                subtitleLabel?.text = ""
            }

            if let title = actionInfo.title {
                if (titleLabel == nil) {
                    titleLabel = UILabel()
                    addSubview(titleLabel!)
                }

                titleLabel?.text = title
                titleLabel?.font = UIFont.systemFont(ofSize: 20)
                titleLabel?.textColor = UIColor(hex: 0x595959)

                titleLabel?.snp.remakeConstraints { (make) in
                    make.height.equalTo(23)

                    if (actionInfo.image != nil) {
                        make.left.equalTo(iconImageView!.snp.right).offset(16)
                    } else {
                        make.left.equalTo(self).offset(22)
                    }

                    make.right.equalTo(self)

                    if (actionInfo.subtitle != nil) {
                        make.top.equalTo(self).offset(8)
                    } else {
                        make.centerY.equalTo(self)
                    }
                }
            } else {
                titleLabel?.text = ""
            }

            if (!actionInfo.enabled) {
                addSubview(disabledView)
                disabledView.isHidden = false
                disabledView.backgroundColor = UIColor.white.withAlphaComponent(0.5)

                disabledView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self).offset(0.5)
                    make.bottom.equalTo(self)
                    make.left.equalTo(self)
                    make.right.equalTo(self)
                }
            } else {
                disabledView.isHidden = true
            }
        }

        layoutIfNeeded()
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        let oldSeparatorColor = separatorBar.backgroundColor
        super.setSelected(selected, animated: animated)
        selectBar.backgroundColor = WThemeManager.sharedInstance.currentTheme.actionSheetSelectColor
        separatorBar.backgroundColor = oldSeparatorColor
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let oldSeparatorColor = separatorBar.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        selectBar.backgroundColor = WThemeManager.sharedInstance.currentTheme.actionSheetSelectColor
        separatorBar.backgroundColor = oldSeparatorColor
    }

    open func setSelectedAction(_ selected: Bool) {
        selectBar.isHidden = !selected

        if let titleLabel = titleLabel {
            titleLabel.font = selected ? UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize) : UIFont.systemFont(ofSize: titleLabel.font.pointSize)
        }

        if let subtitleLabel = subtitleLabel {
            subtitleLabel.font = selected ? UIFont.boldSystemFont(ofSize: subtitleLabel.font.pointSize) : UIFont.systemFont(ofSize: subtitleLabel.font.pointSize)
        }

        isSelectedAction = selected
    }
}

// MARK: Header View
open class WHeaderView: UITableViewHeaderFooterView {
    fileprivate var title: String? {
        didSet {
            commonInit()
        }
    }

    fileprivate var separatorBar = UIView()
    fileprivate var titleLabel: UILabel?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        commonInit()
    }
    open func commonInit() {
        if (!subviews.contains(separatorBar)) {
            addSubview(separatorBar)
        }
        separatorBar.snp.remakeConstraints { (make) in
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
            titleLabel?.textAlignment = .center
            titleLabel?.text = title
            titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titleLabel?.textColor = UIColor(hex: 0x595959)

            titleLabel?.snp.remakeConstraints({ (make) in
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
open class WSelectBar: UIView { }

// MARK: - PickerView Action Sheet
public protocol WPickerActionSheetDelegate: class {
    func pickerViewDoneButtonWasTapped(_ selectedIndex: Int)
    func pickerViewCancelButtonWasTapped()
}

open class WPickerActionSheet<ActionDataType>: WBaseActionSheet<ActionDataType>, WBaseActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    internal var toolbarDoneButton = UIButton()
    internal var toolbarCancelButton = UIButton()
    internal var toolbarContainerView = UIView()
    internal var pickerView: UIPickerView = UIPickerView()
    internal let PICKER_VIEW_HEIGHT: CGFloat = 258.0
    open weak var pickerDelegate: WPickerActionSheetDelegate?

    // MARK: - Initialization
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateIn()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let toolbarRoundedCornerRect = CAShapeLayer()
        toolbarRoundedCornerRect.bounds = toolbarContainerView.frame
        toolbarRoundedCornerRect.position = toolbarContainerView.center
        toolbarRoundedCornerRect.path = UIBezierPath(roundedRect: toolbarContainerView.bounds, byRoundingCorners: UIRectCorner.topLeft.union(.topRight), cornerRadii: CGSize(width: 5, height: 5)).cgPath

        toolbarContainerView.layer.masksToBounds = true
        toolbarContainerView.layer.mask = toolbarRoundedCornerRect

        let pickerRoundedCornerRect = CAShapeLayer()
        pickerRoundedCornerRect.bounds = pickerView.frame
        pickerRoundedCornerRect.position = pickerView.center
        pickerRoundedCornerRect.path = UIBezierPath(roundedRect: pickerView.bounds, byRoundingCorners: UIRectCorner.bottomLeft.union(.bottomRight), cornerRadii: CGSize(width: 5, height: 5)).cgPath

        pickerView.layer.masksToBounds = true
        pickerView.layer.mask = pickerRoundedCornerRect
    }

    open override func commonInit() {
        super.commonInit()

        delegate = self

        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self

        toolbarCancelButton.setTitle("Cancel", for: UIControlState())
        toolbarCancelButton.setTitleColor(UIColor.blue, for: UIControlState())
        toolbarCancelButton.addTarget(self, action: #selector(WPickerActionSheet.toolbarCancelButtonWasTouched), for: .touchUpInside)

        toolbarDoneButton.setTitle("Done", for: UIControlState())
        toolbarDoneButton.setTitleColor(UIColor.blue, for: UIControlState())
        toolbarDoneButton.addTarget(self, action: #selector(WPickerActionSheet.toolbarDoneButtonWasTouched), for: .touchUpInside)

        toolbarContainerView.addSubview(toolbarCancelButton)
        toolbarContainerView.addSubview(toolbarDoneButton)
        toolbarContainerView.backgroundColor = .white

        containerView.addSubview(toolbarContainerView)
        containerView.addSubview(pickerView)

        setupUI(false)
    }

    open override func setupUI(_ animated: Bool) {
        super.setupUI(animated)

        pickerView.reloadAllComponents()

        let height = heightForActionSheet()

        toolbarContainerView.snp.remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(containerView)
        }

        toolbarCancelButton.snp.remakeConstraints { (make) in
            make.left.equalTo(toolbarContainerView).offset(20)
            make.bottom.equalTo(toolbarContainerView).offset(-2)
        }

        toolbarDoneButton.snp.remakeConstraints { (make) in
            make.right.equalTo(toolbarContainerView).offset(-20)
            make.bottom.equalTo(toolbarContainerView).offset(-2)
        }

        pickerView.snp.remakeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(toolbarContainerView.snp.bottom)
            make.bottom.equalTo(containerView.snp.bottom)
        }

        view.layoutIfNeeded()

        if (animated) {
            containerView.snp.remakeConstraints { (make) in
                if (UIDevice.current.userInterfaceIdiom == .pad) {
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

            UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseOut,
                animations: { [weak self] in
                    self?.presentingWindow?.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func toolbarDoneButtonWasTouched(){
        animateOut()
        pickerDelegate?.pickerViewDoneButtonWasTapped(pickerView.selectedRow(inComponent: 0))
    }

    func toolbarCancelButtonWasTouched(){
        animateOut()
        pickerDelegate?.pickerViewCancelButtonWasTapped()
    }

    open func setSelectedAction(_ index: Int) {
        if (index >= actions.count || index < 0) {
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }

    open func heightForActionSheet() -> CGFloat {
        if (actions.count == 0) {
            return CGFloat(0)
        }
        return CGFloat(PICKER_VIEW_HEIGHT)
    }

    // MARK: - UIPickerView Delegate
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actions.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return actions[row].title! as String
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let action: WAction<ActionDataType> = actionForIndex(row)
        action.handler?(action)
    }
}
