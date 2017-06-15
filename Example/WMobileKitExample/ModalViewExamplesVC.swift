//
//  ModalViewExamplesVC.swift
//  WMobileKitExample
//
//  Examples of views that appear over the current content
//
//  Includes: WActionSheetVC, WToast, WBanner
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
import WMobileKit

open class ModalViewExamplesVC: WSideMenuContentVC {
    var topBanner: WBannerView?
    var bottomBanner: WBannerView?

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Action Sheets
        let actionSheetLabel = UILabel()
        actionSheetLabel.text = "Action Sheet Examples"
        actionSheetLabel.textAlignment = NSTextAlignment.center

        view.addSubview(actionSheetLabel)
        actionSheetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let permissionsSheetButton = UIButton(type: UIButtonType.roundedRect)
        permissionsSheetButton.backgroundColor = .lightGray
        permissionsSheetButton.tintColor = .green
        permissionsSheetButton.setTitle("Cancel Action Sheet", for: UIControlState.normal)
        permissionsSheetButton.setTitleColor(.white, for: UIControlState.normal)
        permissionsSheetButton.addTarget(self, action: #selector(presentPermissionsActionSheet(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(permissionsSheetButton)
        permissionsSheetButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionSheetLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let iconSheetButton = UIButton(type: UIButtonType.roundedRect)
        iconSheetButton.backgroundColor = .lightGray
        iconSheetButton.tintColor = .green
        iconSheetButton.setTitle("Scrollable Cancel Action Sheet", for: UIControlState.normal)
        iconSheetButton.setTitleColor(.white, for: UIControlState.normal)
        iconSheetButton.addTarget(self, action: #selector(presentIconActionSheet(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(iconSheetButton)
        iconSheetButton.snp.makeConstraints { (make) in
            make.top.equalTo(permissionsSheetButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(230)
        }

        let scrollNoCancelSheetButton = UIButton(type: UIButtonType.roundedRect)
        scrollNoCancelSheetButton.backgroundColor = .lightGray
        scrollNoCancelSheetButton.tintColor = .green
        scrollNoCancelSheetButton.setTitle("Scrollable Action Sheet", for: UIControlState.normal)
        scrollNoCancelSheetButton.setTitleColor(.white, for: UIControlState.normal)
        scrollNoCancelSheetButton.addTarget(self, action: #selector(presentIconActionSheet(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(scrollNoCancelSheetButton)
        scrollNoCancelSheetButton.snp.makeConstraints { (make) in
            make.top.equalTo(iconSheetButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(230)
        }

        let sortSheetButton = UIButton(type: UIButtonType.roundedRect)
        sortSheetButton.backgroundColor = .lightGray
        sortSheetButton.tintColor = .green
        sortSheetButton.setTitle("Autosize Sheet", for: UIControlState.normal)
        sortSheetButton.setTitleColor(.white, for: UIControlState.normal)
        sortSheetButton.addTarget(self, action: #selector(presentSortActionSheet(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(sortSheetButton)
        sortSheetButton.snp.makeConstraints { (make) in
            make.top.equalTo(scrollNoCancelSheetButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let pickerSheetButton = UIButton(type: UIButtonType.roundedRect)
        pickerSheetButton.backgroundColor = .lightGray
        pickerSheetButton.tintColor = .green
        pickerSheetButton.setTitle("Picker View Sheet", for: UIControlState.normal)
        pickerSheetButton.setTitleColor(.white, for: UIControlState.normal)
        pickerSheetButton.addTarget(self, action: #selector(presentPickerActionSheet(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(pickerSheetButton)
        pickerSheetButton.snp.makeConstraints { (make) in
            make.top.equalTo(sortSheetButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        // Toasts
        let toastLabel = UILabel()
        toastLabel.text = "Toast Examples"
        toastLabel.textAlignment = NSTextAlignment.center

        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pickerSheetButton.snp.bottom).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let autoToastButton = UIButton(type: UIButtonType.roundedRect)
        autoToastButton.backgroundColor = .lightGray
        autoToastButton.tintColor = .green
        autoToastButton.setTitle("Auto Dismiss Toast", for: UIControlState.normal)
        autoToastButton.setTitleColor(.white, for: UIControlState.normal)
        autoToastButton.addTarget(self, action: #selector(presentAutoToast(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(autoToastButton)
        autoToastButton.snp.makeConstraints { (make) in
            make.top.equalTo(toastLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let autoTwoLineToastButton = UIButton(type: UIButtonType.roundedRect)
        autoTwoLineToastButton.backgroundColor = .lightGray
        autoTwoLineToastButton.tintColor = .green
        autoTwoLineToastButton.setTitle("Auto Dismiss Two Line Toast", for: UIControlState.normal)
        autoTwoLineToastButton.setTitleColor(.white, for: UIControlState.normal)
        autoTwoLineToastButton.addTarget(self, action: #selector(presentAutoTwoLineToast(sender:)), for: UIControlEvents.touchUpInside)

        view.addSubview(autoTwoLineToastButton)
        autoTwoLineToastButton.snp.makeConstraints { (make) in
            make.top.equalTo(autoToastButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let tapToastButton = UIButton(type: UIButtonType.roundedRect)
        tapToastButton.backgroundColor = .lightGray
        tapToastButton.tintColor = .green
        tapToastButton.setTitle("Tap Dismiss Toast", for: UIControlState.normal)
        tapToastButton.setTitleColor(.white, for: UIControlState.normal)
        tapToastButton.addTarget(self, action: #selector(presentTapToast(sender:)), for: UIControlEvents.touchUpInside)

        view.addSubview(tapToastButton)
        tapToastButton.snp.makeConstraints { (make) in
            make.top.equalTo(autoTwoLineToastButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let flexibleToastButton = UIButton(type: UIButtonType.roundedRect)
        flexibleToastButton.backgroundColor = .lightGray
        flexibleToastButton.tintColor = .green
        flexibleToastButton.setTitle("Auto Dismiss Flexible Toast", for: UIControlState.normal)
        flexibleToastButton.setTitleColor(.white, for: UIControlState.normal)
        flexibleToastButton.addTarget(self, action: #selector(presentFlexibleToast(sender:)), for: UIControlEvents.touchUpInside)

        view.addSubview(flexibleToastButton)
        flexibleToastButton.snp.makeConstraints { (make) in
            make.top.equalTo(tapToastButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        // Banners
        let bannerLabel = UILabel()
        bannerLabel.text = "Banner Examples"
        bannerLabel.textAlignment = NSTextAlignment.center

        view.addSubview(bannerLabel)
        bannerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flexibleToastButton.snp.bottom).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let topBannerButton = UIButton(type: UIButtonType.roundedRect)
        topBannerButton.backgroundColor = UIColor.lightGray
        topBannerButton.tintColor = UIColor.green
        topBannerButton.setTitle("Top Banner", for: UIControlState.normal)
        topBannerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        topBannerButton.addTarget(self, action: #selector(presentTopBanner(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(topBannerButton)
        topBannerButton.snp.makeConstraints { (make) in
            make.top.equalTo(bannerLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let bottomBannerButton = UIButton(type: UIButtonType.roundedRect)
        bottomBannerButton.backgroundColor = UIColor.lightGray
        bottomBannerButton.tintColor = UIColor.green
        bottomBannerButton.setTitle("Bottom Banner", for: UIControlState.normal)
        bottomBannerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        bottomBannerButton.addTarget(self, action: #selector(presentBottomBanner(_:)), for: UIControlEvents.touchUpInside)

        view.addSubview(bottomBannerButton)
        bottomBannerButton.snp.makeConstraints { (make) in
            make.top.equalTo(topBannerButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }
        
        view.layoutIfNeeded()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    @objc open func presentPermissionsActionSheet(_ sender: UIButton) {
        definesPresentationContext = true

        let actionSheet = WActionSheetVC<String>()
        // Reference needs to be weak in the blocks to prevent retain cycles
        weak var weakActionSheet = actionSheet

        actionSheet.titleString = "User Permissions"

        // Fake this cell to look disabled but still allow it to be tapped/selected
        var titleCellOptions = [WActionSheetOptions: Any]()
        titleCellOptions[WActionSheetOptions.cellTitleColor] = UIColor.darkGray.withAlphaComponent(0.5)
        titleCellOptions[WActionSheetOptions.cellSubtitleColor] = UIColor.darkGray.withAlphaComponent(0.5)
        actionSheet.addAction(
            WAction(title: "Owner", subtitle: "Has full editing rights. May set other users' permissions.",
                handler: { action in
                    NSLog(action.title! + " was tapped")
                },
                options: titleCellOptions
            )
        )

        actionSheet.addAction(WAction(title: "Editor", subtitle: "May view and make changes to the document.",
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
                weakActionSheet?.animateOut()
        }))
        actionSheet.addAction(WAction(title: "Viewer", subtitle: "May only view and comment on the document.",
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
                weakActionSheet?.animateOut()
        }))
        actionSheet.addAction(WAction(title: "None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", style: ActionStyle.destructive, enabled: false,
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
                weakActionSheet?.animateOut()
        }))

        actionSheet.setSelectedAction(1)
        actionSheet.hasCancel = true
        actionSheet.dismissOnAction = false
        actionSheet.popoverPresentationController?.sourceView = sender

        present(actionSheet, animated: true, completion: nil)
    }

    @objc open func presentIconActionSheet(_ sender: UIButton) {
        definesPresentationContext = true

        let actionSheetIcons = WActionSheetVC<String>()

        actionSheetIcons.titleString = "Scrollable Action Sheet"
        actionSheetIcons.maxSheetHeight = 315
        actionSheetIcons.executeActionAfterDismissal = true
        
        actionSheetIcons.addAction(WAction(title: "Open folder", image:UIImage(named: "folder"), style: ActionStyle.normal, enabled: false,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Properties", image:UIImage(named: "gear"), style: ActionStyle.normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Permissions", image:UIImage(named: "person"), style: ActionStyle.normal, enabled: false,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Alerts", image:UIImage(named: "alert"), style: ActionStyle.normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Delete", image:UIImage(named: "trash"), style: ActionStyle.destructive,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))

        if let titleString = sender.currentTitle {
            actionSheetIcons.hasCancel = titleString.contains("Cancel")
        }

        actionSheetIcons.dismissOnAction = true
        actionSheetIcons.popoverPresentationController?.sourceView = sender

        present(actionSheetIcons, animated: true, completion: nil)
    }

    @objc open func presentSortActionSheet(_ sender: UIButton) {
        definesPresentationContext = true

        let actionSheetSort = WActionSheetVC<String>()
        // Reference needs to be weak in the blocks to prevent retain cycles
        weak var weakActionSheet = actionSheetSort

        actionSheetSort.titleString = "Sort"
        actionSheetSort.addAction(WAction(title: "First Name",
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Last Name",
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
        }))

        var titleCellOptions = [WActionSheetOptions: Any]()
        titleCellOptions[WActionSheetOptions.cellTitleColor] = UIColor.purple

        actionSheetSort.addAction(WAction(title: "Title",
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
            },
            options: titleCellOptions
        ))

        actionSheetSort.addAction(WAction(title: "Modified Date", enabled: false,
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Creation Date", enabled: false,
            handler: { action in
                NSLog(action.title! + " was tapped")
                weakActionSheet?.deselectAction()
                weakActionSheet?.setSelectedAction(action)
        }))

        actionSheetSort.hasCancel = false
        actionSheetSort.dismissOnAction = false
        actionSheetSort.setSelectedAction(1)
        actionSheetSort.sheetSeparatorStyle = .all
        actionSheetSort.popoverPresentationController?.sourceView = sender
        
        present(actionSheetSort, animated: true, completion: nil)
    }

    @objc open func presentPickerActionSheet(_ sender: UIButton) {
        self.definesPresentationContext = true

        let actionSheetPicker = WPickerActionSheet<String>()
        actionSheetPicker.pickerDelegate = self

        actionSheetPicker.addAction(WAction(title: "Option 1",
            handler: { action in
                print("\(action.title!) was stopped on.")
        }))
        actionSheetPicker.addAction(WAction(title: "Option 2",
            handler: { action in
                print("\(action.title!) was stopped on.")
        }))
        actionSheetPicker.addAction(WAction(title: "Option 3",
            handler: { action in
                print("\(action.title!) was stopped on.")
        }))
        actionSheetPicker.addAction(WAction(title: "Option 4",
            handler: { action in
                print("\(action.title!) was stopped on.")
        }))
        actionSheetPicker.addAction(WAction(title: "Option 5",
            handler: { action in
                print("\(action.title!) was stopped on.")
        }))
        actionSheetPicker.popoverPresentationController?.sourceView = sender
        actionSheetPicker.setSelectedAction(2)

        present(actionSheetPicker, animated: true, completion: nil)
    }

    @objc open func presentAutoToast(_ sender: UIButton) {
        let toast = WToastView(message: "Auto Dismiss Toast", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        toast.showDuration = 3
        toast.placement = .top
        toast.width = 250
        WToastManager.sharedInstance.showToast(toast)
    }

    @objc open func presentAutoTwoLineToast(sender: UIButton) {
        let toast = WToastTwoLineView(firstLine: "This is the first line, that will be truncated on its own.", secondLine: "This is the second line, notice how the first line did not hide this text.")
        toast.showDuration = 3
        WToastManager.sharedInstance.showToast(toast)
    }

    @objc open func presentTapToast(sender: UIButton) {
        let toast = WToastView(message: "Tap Dismiss Toast", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        toast.showDuration = 0
        toast.flyInDirection = .fromRight
        toast.widthRatio = 0.65
        toast.bottomPadding = 100
        WToastManager.sharedInstance.showToast(toast)
    }

    @objc open func presentFlexibleToast(sender: UIButton) {
        let toast = WToastFlexibleView(message: "This is a flexible toast. It will factor in the allowed width of the toast and then adjust the height to ensure that all of this text is present and does not get truncated.", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        toast.maxHeight = 192
        toast.showDuration = 0
        toast.flyInDirection = .fromBottom
        toast.widthRatio = 0.65
        toast.bottomPadding = 100
        toast.showDuration = 3
        WToastManager.sharedInstance.showToast(toast)
    }

    @objc open func presentTopBanner(_ sender: UIButton) {
        topBanner?.hide()

        topBanner = WBannerView(rootView: view,
            titleMessage: "Top Banner Title",
            titleIcon: UIImage(named: "alert"),
            bodyMessage: "This is the top tap to dismiss banner body. Banners can be dismissed by tapping them.",
            rightIcon: UIImage(named: "close"),
            bannerColor: UIColor(hex: 0x006400),
            bannerAlpha: 0.8)
        topBanner!.delegate = self
        topBanner!.placement = .top
        topBanner!.hideOptions = .dismissOnTap
        topBanner!.show()
    }

    @objc open func presentBottomBanner(_ sender: UIButton) {
        bottomBanner?.hide()

        bottomBanner = WBannerView(rootView: view,
            titleMessage: "Bottom Banner Title",
            titleIcon: nil,
            bodyMessage: "Body. Banners can be dismissed on a timer.",
            bannerColor: UIColor(hex: 0x006400))
        bottomBanner!.delegate = self
        bottomBanner!.show()
    }
}

// MARK: - WPickerActionSheetDelegate
extension ModalViewExamplesVC: WPickerActionSheetDelegate {
    public func pickerViewDoneButtonWasTapped(_ selectedIndex: Int) {
        NSLog("The Picker View \"Done\" button was pressed with selected index \(selectedIndex).")
    }

    public func pickerViewCancelButtonWasTapped() {
        NSLog("The Pick View \"Cancel\" button was pressed.")
    }
}

// Mark: - WBannerDelegate
extension ModalViewExamplesVC: WBannerViewDelegate {
    public func bannerWasTapped(_ sender: UITapGestureRecognizer) {
        let bannerView = sender.view as! WBannerView

        NSLog("Banner '" + bannerView.titleMessageLabel.text! + "' was tapped")
    }

    public func bannerDidHide(_ bannerView: WBannerView) {
        NSLog("Banner '" + bannerView.titleMessageLabel.text! + "' did hide")
    }
}
