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
        button.addTarget(self, action: #selector(WMobileKitPagingControlExamplesVC.presentActionSheet), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        let actionSheet = WActionSheetVC()
        
        actionSheet.titleString = "Jordan Ross"
        actionSheet.addAction("Owner", subtitle: "Has full editing rights. May set other users' permissions.")
        actionSheet.addAction("Editor", subtitle: "May view and make changes to the document.")
        actionSheet.addAction("Viewer", subtitle: "May only view and comment on the document.")
        actionSheet.addAction("None (Remove Access)", subtitle: "Removes the collaborator's access to the document.", style: ActionStyle.Destructive)
        actionSheet.hasCancel = true
        
        self.definesPresentationContext = true
        
        actionSheet.modalPresentationStyle = .OverFullScreen
        actionSheet.modalTransitionStyle = .CrossDissolve
        actionSheet.providesPresentationContextTransitionStyle = true
        actionSheet.view.window?.windowLevel = UIWindowLevelStatusBar + 10
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

