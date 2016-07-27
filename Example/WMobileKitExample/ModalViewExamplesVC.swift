//
//  ModalViewExamplesVC.swift
//  WMobileKitExample
//
//  Examples of views that appear over the current content
//
//  Includes: WActionSheetVC, WToast, WBanner
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
import WMobileKit

public class ModalViewExamplesVC: WSideMenuContentVC {
    var topBanner: WBannerView?
    var bottomBanner: WBannerView?

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Action Sheets
        let actionSheetLabel = UILabel()
        actionSheetLabel.text = "Action Sheet Examples"
        actionSheetLabel.textAlignment = NSTextAlignment.Center

        view.addSubview(actionSheetLabel)
        actionSheetLabel.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let permissionsSheetButton = UIButton(type: UIButtonType.RoundedRect)
        permissionsSheetButton.backgroundColor = .lightGrayColor()
        permissionsSheetButton.tintColor = .greenColor()
        permissionsSheetButton.setTitle("Cancel Action Sheet", forState: UIControlState.Normal)
        permissionsSheetButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        permissionsSheetButton.addTarget(self, action: #selector(presentPermissionsActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(permissionsSheetButton)
        permissionsSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(actionSheetLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let iconSheetButton = UIButton(type: UIButtonType.RoundedRect)
        iconSheetButton.backgroundColor = .lightGrayColor()
        iconSheetButton.tintColor = .greenColor()
        iconSheetButton.setTitle("Scrollable Cancel Action Sheet", forState: UIControlState.Normal)
        iconSheetButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        iconSheetButton.addTarget(self, action: #selector(presentIconActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(iconSheetButton)
        iconSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(permissionsSheetButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(230)
        }

        let scrollNoCancelSheetButton = UIButton(type: UIButtonType.RoundedRect)
        scrollNoCancelSheetButton.backgroundColor = .lightGrayColor()
        scrollNoCancelSheetButton.tintColor = .greenColor()
        scrollNoCancelSheetButton.setTitle("Scrollable Action Sheet", forState: UIControlState.Normal)
        scrollNoCancelSheetButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        scrollNoCancelSheetButton.addTarget(self, action: #selector(presentIconActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(scrollNoCancelSheetButton)
        scrollNoCancelSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(iconSheetButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(230)
        }

        let sortSheetButton = UIButton(type: UIButtonType.RoundedRect)
        sortSheetButton.backgroundColor = .lightGrayColor()
        sortSheetButton.tintColor = .greenColor()
        sortSheetButton.setTitle("Autosize Sheet", forState: UIControlState.Normal)
        sortSheetButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        sortSheetButton.addTarget(self, action: #selector(presentSortActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(sortSheetButton)
        sortSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(scrollNoCancelSheetButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let pickerSheetButton = UIButton(type: UIButtonType.RoundedRect)
        pickerSheetButton.backgroundColor = .lightGrayColor()
        pickerSheetButton.tintColor = .greenColor()
        pickerSheetButton.setTitle("Picker View Sheet", forState: UIControlState.Normal)
        pickerSheetButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        pickerSheetButton.addTarget(self, action: #selector(presentPickerActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(pickerSheetButton)
        pickerSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(sortSheetButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        // Toasts
        let toastLabel = UILabel()
        toastLabel.text = "Toast Examples"
        toastLabel.textAlignment = NSTextAlignment.Center

        view.addSubview(toastLabel)
        toastLabel.snp_makeConstraints { (make) in
            make.top.equalTo(pickerSheetButton.snp_bottom).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let autoToastButton = UIButton(type: UIButtonType.RoundedRect)
        autoToastButton.backgroundColor = .lightGrayColor()
        autoToastButton.tintColor = .greenColor()
        autoToastButton.setTitle("Auto Dismiss Toast", forState: UIControlState.Normal)
        autoToastButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        autoToastButton.addTarget(self, action: #selector(presentAutoToast(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(autoToastButton)
        autoToastButton.snp_makeConstraints { (make) in
            make.top.equalTo(toastLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let tapToastButton = UIButton(type: UIButtonType.RoundedRect)
        tapToastButton.backgroundColor = .lightGrayColor()
        tapToastButton.tintColor = .greenColor()
        tapToastButton.setTitle("Tap Dismiss Toast", forState: UIControlState.Normal)
        tapToastButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        tapToastButton.addTarget(self, action: #selector(presentTapToast(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(tapToastButton)
        tapToastButton.snp_makeConstraints { (make) in
            make.top.equalTo(autoToastButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        view.layoutIfNeeded()

        // Banners
        let bannerLabel = UILabel()
        bannerLabel.text = "Banner Examples"
        bannerLabel.textAlignment = NSTextAlignment.Center

        view.addSubview(bannerLabel)
        bannerLabel.snp_makeConstraints { (make) in
            make.top.equalTo(tapToastButton.snp_bottom).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let topBannerButton = UIButton(type: UIButtonType.RoundedRect)
        topBannerButton.backgroundColor = UIColor.lightGrayColor()
        topBannerButton.tintColor = UIColor.greenColor()
        topBannerButton.setTitle("Top Banner", forState: UIControlState.Normal)
        topBannerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        topBannerButton.addTarget(self, action: #selector(presentTopBanner(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(topBannerButton)
        topBannerButton.snp_makeConstraints { (make) in
            make.top.equalTo(bannerLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let bottomBannerButton = UIButton(type: UIButtonType.RoundedRect)
        bottomBannerButton.backgroundColor = UIColor.lightGrayColor()
        bottomBannerButton.tintColor = UIColor.greenColor()
        bottomBannerButton.setTitle("Bottom Banner", forState: UIControlState.Normal)
        bottomBannerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bottomBannerButton.addTarget(self, action: #selector(presentBottomBanner(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(bottomBannerButton)
        bottomBannerButton.snp_makeConstraints { (make) in
            make.top.equalTo(topBannerButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }
        
        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    public func presentPermissionsActionSheet(sender: UIButton) {
        definesPresentationContext = true

        let actionSheet = WActionSheetVC<String>()
        actionSheet.titleString = "User Permissions"

        actionSheet.addAction(WAction(title: "Owner", subtitle: "Has full editing rights. May set other users' permissions.",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheet.deselectAction()
                actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Editor", subtitle: "May view and make changes to the document.",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheet.deselectAction()
                actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Viewer", subtitle: "May only view and comment on the document.",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheet.deselectAction()
                actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", style: ActionStyle.Destructive,
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheet.deselectAction()
                actionSheet.setSelectedAction(action)
        }))

        actionSheet.setSelectedAction(1)
        actionSheet.hasCancel = true
        actionSheet.dismissOnAction = true
        actionSheet.popoverPresentationController?.sourceView = sender

        presentViewController(actionSheet, animated: true, completion: nil)
    }

    public func presentIconActionSheet(sender: UIButton) {
        definesPresentationContext = true

        let actionSheetIcons = WActionSheetVC<String>()

        actionSheetIcons.titleString = "Scrollable Action Sheet"
        actionSheetIcons.maxSheetHeight = 315
        actionSheetIcons.executeActionAfterDismissal = true
        
        actionSheetIcons.addAction(WAction(title: "Open folder", image:UIImage(named: "folder"), style: ActionStyle.Normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Properties", image:UIImage(named: "gear"), style: ActionStyle.Normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Permissions", image:UIImage(named: "person"), style: ActionStyle.Normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Alerts", image:UIImage(named: "alert"), style: ActionStyle.Normal,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Delete", image:UIImage(named: "trash"), style: ActionStyle.Destructive,
            handler: { action in
                NSLog(action.title! + " was tapped")
        }))

        if let titleString = sender.currentTitle {
            actionSheetIcons.hasCancel = titleString.containsString("Cancel")
        }

        actionSheetIcons.dismissOnAction = true
        actionSheetIcons.popoverPresentationController?.sourceView = sender

        presentViewController(actionSheetIcons, animated: true, completion: nil)
    }

    public func presentSortActionSheet(sender: UIButton) {
        definesPresentationContext = true

        let actionSheetSort = WActionSheetVC<String>()

        actionSheetSort.titleString = "Sort"
        actionSheetSort.addAction(WAction(title: "First Name",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Last Name",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Title",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Subtitle",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Section",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Modified Date",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Creation Date",
            handler: { action in
                NSLog(action.title! + " was tapped")
                actionSheetSort.deselectAction()
                actionSheetSort.setSelectedAction(action)
        }))

        actionSheetSort.hasCancel = false
        actionSheetSort.dismissOnAction = false
        actionSheetSort.setSelectedAction(1)
        actionSheetSort.sheetSeparatorStyle = .All
        actionSheetSort.popoverPresentationController?.sourceView = sender
        
        presentViewController(actionSheetSort, animated: true, completion: nil)
    }

    public func presentPickerActionSheet(sender: UIButton) {
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

        presentViewController(actionSheetPicker, animated: true, completion: nil)
    }

    public func presentAutoToast(sender: UIButton) {
        let toast = WToastView(message: "Auto Dismiss Toast", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        toast.showDuration = 3
        toast.placement = .Top
        toast.width = 250
        WToastManager.sharedInstance.showToast(toast)
    }

    public func presentTapToast(sender: UIButton) {
        let toast = WToastView(message: "Tap Dismiss Toast", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        toast.showDuration = 0
        toast.flyInDirection = .FromRight
        toast.widthRatio = 0.65
        toast.bottomPadding = 100
        WToastManager.sharedInstance.showToast(toast)
    }

    public func presentTopBanner(sender: UIButton) {
        topBanner?.hide()

        topBanner = WBannerView(rootView: view,
                                 titleMessage: "Top Banner Title",
                                 titleIcon: UIImage(named: "alert"),
                                 bodyMessage: "This is the top tap to dismiss banner body. Banners can be dismissed by tapping them.",
                                 rightIcon: UIImage(named: "close"),
                                 bannerColor: UIColor(hex: 0x006400),
                                 bannerAlpha: 0.8)
        topBanner!.delegate = self
        topBanner!.placement = .Top
        topBanner!.hideOptions = .DismissOnTap
        topBanner!.show()
    }

    public func presentBottomBanner(sender: UIButton) {
        bottomBanner?.hide()

        bottomBanner = WBannerView(rootView: view,
                                 titleMessage: "Bottom Banner Title",
                                 titleIcon: UIImage(named: "alert"),
                                 bodyMessage: "Body. Banners can be dismissed on a timer.",
                                 bannerColor: UIColor(hex: 0x006400))
        bottomBanner!.bodyNumberOfLines = 1
        bottomBanner!.delegate = self
        bottomBanner!.show()
    }

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition(
            { context in
                if (size.height < size.width) {
                    // Landscape
                    self.topBanner?.bodyNumberOfLines = 1
                } else {
                    // Portrait
                    self.topBanner?.bodyNumberOfLines = 2
                }},
            completion: nil)
    }
}

// MARK: - WPickerActionSheetDelegate
extension ModalViewExamplesVC: WPickerActionSheetDelegate {
    public func pickerViewDoneButtonWasTapped(selectedIndex: Int) {
        NSLog("The Picker View \"Done\" button was pressed with selected index \(selectedIndex).")
    }

    public func pickerViewCancelButtonWasTapped() {
        NSLog("The Pick View \"Cancel\" button was pressed.")
    }
}

// Mark: - WBannerDelegate
extension ModalViewExamplesVC: WBannerViewDelegate {
    public func bannerWasTapped(sender: UITapGestureRecognizer) {
        let bannerView = sender.view as! WBannerView

        NSLog("Banner '" + bannerView.titleMessageLabel.text! + "' was tapped")
    }

    public func bannerDidHide(bannerView: WBannerView) {
        NSLog("Banner '" + bannerView.titleMessageLabel.text! + "' did hide")
    }
}