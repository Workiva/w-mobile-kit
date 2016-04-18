//
//  WMobileKitPagingControlExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class WMobileKitPagingControlExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let tabLayout1 = WPagingSelectorControl(titles: ["Recent", "All Files"])
        
        view.addSubview(tabLayout1);
        tabLayout1.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(view)
        }
        
        tabLayout1.tabTextColor = UIColor.redColor()
        
        let tabLayout2 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"])

        view.addSubview(tabLayout2);
        tabLayout2.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout1.snp_bottom)
        }

        let tabLayout3 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"], tabWidth: 90)
        
        view.addSubview(tabLayout3);
        tabLayout3.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout2.snp_bottom)
        }
        
        let tabLayout4 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff"], tabWidth: 90)
        
        view.addSubview(tabLayout4);
        tabLayout4.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout3.snp_bottom)
        }

        let tabLayout5 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff", "Too many"], tabWidth: 90)
        
        view.addSubview(tabLayout5);
        tabLayout5.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout4.snp_bottom)
        }
        
        let button = UIButton(type: UIButtonType.RoundedRect)
        button.backgroundColor = UIColor.lightGrayColor()
        button.tintColor = UIColor.greenColor()
        button.setTitle("Selection Sheet!", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(WMobileKitPagingControlExamplesVC.presentActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-32)
            make.centerX.equalTo(view)
            make.width.equalTo(112)
        }
        
        let button2 = UIButton(type: UIButtonType.RoundedRect)
        button2.backgroundColor = UIColor.lightGrayColor()
        button2.tintColor = UIColor.greenColor()
        button2.setTitle("Icon Sheet!", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button2.addTarget(self, action: #selector(WMobileKitPagingControlExamplesVC.presentIconActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button2)
        button2.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-32)
            make.right.equalTo(button.snp_left).offset(-16)
            make.width.equalTo(112)
        }
        
        let button3 = UIButton(type: UIButtonType.RoundedRect)
        button3.backgroundColor = UIColor.lightGrayColor()
        button3.tintColor = UIColor.greenColor()
        button3.setTitle("Sort Sheet!", forState: UIControlState.Normal)
        button3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button3.addTarget(self, action: #selector(WMobileKitPagingControlExamplesVC.presentSortActionSheet(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button3)
        button3.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-32)
            make.left.equalTo(button.snp_right).offset(16)
            make.width.equalTo(112)
        }
        
        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
    
    public func presentActionSheet(sender: UIButton) {
        self.definesPresentationContext = true
        
        let actionSheet = WActionSheetVC<String>()
        
        actionSheet.titleString = "Jordan Ross"
        actionSheet.addAction(WAction(title: "Owner", subtitle: "Has full editing rights. May set other users' permissions.", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Editor", subtitle: "May view and make changes to the document.", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "Viewer", subtitle: "May only view and comment on the document.", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheet.deselectAction()
            actionSheet.setSelectedAction(action)
        }))
        actionSheet.addAction(WAction(title: "None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", style: ActionStyle.Destructive, handler: { action in
            NSLog("We have tapped " + action.title!)
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
        actionSheetIcons.addAction(WAction(title: "Open in viewer", image:UIImage(named: "folder_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
        }))
        actionSheetIcons.addAction(WAction(title: "Properties", image:UIImage(named: "gear_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
        }))
        actionSheetIcons.addAction(WAction(title: "Permissions", image:UIImage(named: "person_1"), style: ActionStyle.Normal, handler: { action in
            NSLog("We have tapped " + action.title!)
        }))
        actionSheetIcons.addAction(WAction(title: "Delete", image:UIImage(named: "trash_1"), style: ActionStyle.Destructive, handler: { action in
            NSLog("We have tapped " + action.title!)
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
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "File", handler: { action in
            NSLog("We have tapped " + action.title!)
            actionSheetSort.deselectAction()
            actionSheetSort.setSelectedAction(action)
        }))
        actionSheetSort.addAction(WAction(title: "Assigner", handler: { action in
            NSLog("We have tapped " + action.title!)
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
}

