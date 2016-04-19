//
//  ModalViewExamplesVC.swift
//  WMobileKitExample
//
//  Examples of views that appear over the current content
//
//  Includes: WActionSheetVC, WToastManager
//

import Foundation
import WMobileKit

public class ModalViewExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Action Sheets
        let actionSheetLabel = UILabel()
        actionSheetLabel.text = "Action Sheet Examples"
        actionSheetLabel.textAlignment = NSTextAlignment.Center

        view.addSubview(actionSheetLabel)
        actionSheetLabel.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top).offset(32)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let permissionsSheetButton = UIButton(type: UIButtonType.RoundedRect)
        permissionsSheetButton.backgroundColor = UIColor.lightGrayColor()
        permissionsSheetButton.tintColor = UIColor.greenColor()
        permissionsSheetButton.setTitle("Selection Cancel Sheet", forState: UIControlState.Normal)
        permissionsSheetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        permissionsSheetButton.addTarget(self, action: #selector(presentPermissionsActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(permissionsSheetButton)
        permissionsSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(actionSheetLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        let iconSheetButton = UIButton(type: UIButtonType.RoundedRect)
        iconSheetButton.backgroundColor = UIColor.lightGrayColor()
        iconSheetButton.tintColor = UIColor.greenColor()
        iconSheetButton.setTitle("Icon Dismiss Cancel Sheet", forState: UIControlState.Normal)
        iconSheetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        iconSheetButton.addTarget(self, action: #selector(presentIconActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(iconSheetButton)
        iconSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(permissionsSheetButton.snp_bottom).offset(25)
            make.centerX.equalTo(view)
            make.width.equalTo(230)
        }

        let sortSheetButton = UIButton(type: UIButtonType.RoundedRect)
        sortSheetButton.backgroundColor = UIColor.lightGrayColor()
        sortSheetButton.tintColor = UIColor.greenColor()
        sortSheetButton.setTitle("Selection Dismiss Sheet", forState: UIControlState.Normal)
        sortSheetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sortSheetButton.addTarget(self, action: #selector(presentSortActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(sortSheetButton)
        sortSheetButton.snp_makeConstraints { (make) in
            make.top.equalTo(iconSheetButton.snp_bottom).offset(25)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
        }

        // Toasts
        let toastLabel = UILabel()
        toastLabel.text = "Toast Examples"
        toastLabel.textAlignment = NSTextAlignment.Center

        view.addSubview(toastLabel)
        toastLabel.snp_makeConstraints { (make) in
            make.top.equalTo(sortSheetButton.snp_bottom).offset(32)
            make.centerX.equalTo(view)
            make.width.equalTo(220)
        }

        let simpleToastButton = UIButton(type: UIButtonType.RoundedRect)
        simpleToastButton.backgroundColor = UIColor.lightGrayColor()
        simpleToastButton.tintColor = UIColor.greenColor()
        simpleToastButton.setTitle("Simple Toast", forState: UIControlState.Normal)
        simpleToastButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        simpleToastButton.addTarget(self, action: #selector(presentSimpleToast(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(simpleToastButton)
        simpleToastButton.snp_makeConstraints { (make) in
            make.top.equalTo(toastLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(112)
        }

        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    public func presentPermissionsActionSheet(sender: UIButton) {
        self.definesPresentationContext = true

        let actionSheet = WActionSheetVC<String>()
        actionSheet.titleString = "User Permissions"

        actionSheet.addAction(WAction(title: "Owner", subtitle: "Has full editing rights. May set other users' permissions.", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Editor", subtitle: "May view and make changes to the document.", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Viewer", subtitle: "May only view and comment on the document.", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", style: ActionStyle.Destructive, handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))

        actionSheet.setSelectedAction(1)
        actionSheet.hasCancel = true
        actionSheet.dismissOnAction = false
        actionSheet.popoverPresentationController?.sourceView = sender

        presentViewController(actionSheet, animated: true, completion: nil)
    }

    public func presentIconActionSheet(sender: UIButton) {
        self.definesPresentationContext = true

        let actionSheetIcons = WActionSheetVC<String>()

        actionSheetIcons.titleString = "2015 Revenue Forecasts"
        actionSheetIcons.addAction(WAction(title: "Open in viewer", image:UIImage(named: "folder"), style: ActionStyle.Normal, handler: { action in
            NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Properties", image:UIImage(named: "gear"), style: ActionStyle.Normal, handler: { action in
            NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Permissions", image:UIImage(named: "person"), style: ActionStyle.Normal, handler: { action in
            NSLog(action.title! + " was tapped")
        }))
        actionSheetIcons.addAction(WAction(title: "Delete", image:UIImage(named: "trash"), style: ActionStyle.Destructive, handler: { action in
            NSLog(action.title! + " was tapped")
        }))

        actionSheetIcons.hasCancel = true
        actionSheetIcons.dismissOnAction = true
        actionSheetIcons.popoverPresentationController?.sourceView = sender

        presentViewController(actionSheetIcons, animated: true, completion: nil)
    }

    public func presentSortActionSheet(sender: UIButton) {
        self.definesPresentationContext = true

        let actionSheetSort = WActionSheetVC<String>()

        actionSheetSort.titleString = "Sort Tasks"
        actionSheetSort.addAction(WAction(title: "Status", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "File", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Assigner", handler: { action in
            NSLog(action.title! + " was tapped")
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))

        actionSheetSort.hasCancel = false
        actionSheetSort.dismissOnAction = true
        actionSheetSort.setSelectedAction(1)
        actionSheetSort.sheetSeparatorStyle = .All
        actionSheetSort.popoverPresentationController?.sourceView = sender

        presentViewController(actionSheetSort, animated: true, completion: nil)
    }

    public func presentSimpleToast(sender: UIButton) {
        let toast = WToastView(message: "Simple Toast", icon: UIImage(named: "close"), toastColor: UIColor(hex: 0x006400))
        WToastManager.sharedInstance.showToast(toast)
    }
}

