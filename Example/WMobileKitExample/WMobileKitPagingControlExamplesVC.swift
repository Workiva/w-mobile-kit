//
//  WMobileKitPagingControlExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class WMobileKitPagingControlExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let tabLayout1 = WPagingSelectorVC()
        let pages1 = [
            WPage(title: "Recent"),
            WPage(title: "All Files")
        ]
        tabLayout1.pages = pages1
        
        view.addSubview(tabLayout1.view);
        tabLayout1.view.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(view)
        }
        
        let tabLayout2 = WPagingSelectorVC()
        let pages2 = [
            WPage(title: "Recent"),
            WPage(title: "All Files"),
            WPage(title: "Snapshots")
        ]
        tabLayout2.pages = pages2
        
        view.addSubview(tabLayout2.view);
        tabLayout2.view.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout1.view.snp_bottom)
        }

        let tabLayout3 = WPagingSelectorVC()
        let pages3 = [
            WPage(title: "Recent"),
            WPage(title: "All Files"),
            WPage(title: "Snapshots")
        ]
        tabLayout3.pages = pages3
        tabLayout3.tabWidth = 90
        
        view.addSubview(tabLayout3.view);
        tabLayout3.view.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout2.view.snp_bottom)
        }
        
        let tabLayout4 = WPagingSelectorVC()
        let pages4 = [
            WPage(title: "Recent"),
            WPage(title: "All Files"),
            WPage(title: "Snapshots"),
            WPage(title: "Cool stuff")
        ]
        tabLayout4.pages = pages4
        
        view.addSubview(tabLayout4.view);
        tabLayout4.view.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout3.view.snp_bottom)
        }

        let tabLayout5 = WPagingSelectorVC()
        let pages5 = [
            WPage(title: "Recent"),
            WPage(title: "All Files"),
            WPage(title: "Snapshots"),
            WPage(title: "Cool stuff"),
            WPage(title: "Too many")
        ]
        tabLayout5.pages = pages5
        
        view.addSubview(tabLayout5.view);
        tabLayout5.view.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout4.view.snp_bottom)
        }
        
        let button = UIButton(type: UIButtonType.RoundedRect)
        button.backgroundColor = UIColor.lightGrayColor()
        button.tintColor = UIColor.greenColor()
        button.titleLabel?.text = "Action Sheet!"
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.addTarget(self, action: #selector(WMobileKitPagingControlExamplesVC.presentSortActionSheet), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-32)
            make.centerX.equalTo(view)
            make.width.equalTo(128)
        }
        
        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
    
    public func presentActionSheet() {
        self.definesPresentationContext = true
        
        let actionSheet = WActionSheetVC<String>()
        
        actionSheet.titleString = "Jordan Ross"
        actionSheet.addAction(WAction(title: "Owner", subtitle: "Has full editing rights. May set other users' permissions.", image:UIImage(named: "person_1"), data: "", style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Editor", subtitle: "May view and make changes to the document.", image:UIImage(named: "folder_1"), data: nil, style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Viewer", subtitle: "May only view and comment on the document.", data: nil, style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", data: nil, style: ActionStyle.Destructive, handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))

        actionSheet.setSelectedAction(1)
        actionSheet.hasCancel = true
        actionSheet.dismissOnAction = false
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    public func presentIconActionSheet() {
        self.definesPresentationContext = true
        
        let actionSheetIcons = WActionSheetVC<String>()
        
        actionSheetIcons.titleString = "2015 Revenue Forecasts"
        actionSheetIcons.addAction(WAction(title: "Open in viewer", image:UIImage(named: "folder_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            //            actionSheet.toggleSelectedAction(action)
        }))
        actionSheetIcons.addAction(WAction(title: "Properties", image:UIImage(named: "gear_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            //            actionSheet.toggleSelectedAction(action)
        }))
        actionSheetIcons.addAction(WAction(title: "Permissions", image:UIImage(named: "person_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            //            actionSheet.toggleSelectedAction(action)
        }))
        actionSheetIcons.addAction(WAction(title: "Delete", image:UIImage(named: "trash_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
            //            actionSheet.toggleSelectedAction(action)
        }))
        
        actionSheetIcons.hasCancel = true
        actionSheetIcons.dismissOnAction = true
        
        presentViewController(actionSheetIcons, animated: true, completion: nil)
    }
    
    public func presentSortActionSheet() {
        self.definesPresentationContext = true
        
        let actionSheetSort = WActionSheetVC<String>()
        
        actionSheetSort.titleString = "Sort Files"
        actionSheetSort.addAction(WAction(title: "Last Opened", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Last Modified", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Create Date", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Name", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        
        actionSheetSort.hasCancel = true
        actionSheetSort.dismissOnAction = true
        actionSheetSort.setSelectedAction(1)
        
        presentViewController(actionSheetSort, animated: true, completion: nil)
    }
    
    public func presentiPad() {
        
    }
}

