//
//  PagingControlExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class PagingControlExamplesVC: WSideMenuContentVC {
    let tab1Name = "Tab 1"
    let tab2Name = "Tab 2"
    let tab3Name = "Tab 3"
    let tab4Name = "Tab 4"
    let tab5Name = "Tab 5"

    public override func viewDidLoad() {
        super.viewDidLoad()

        let pagingSelectorControl1 = WPagingSelectorControl(titles: [tab1Name, tab2Name])
        pagingSelectorControl1.tabTextColor = UIColor.redColor()
        
        view.addSubview(pagingSelectorControl1);
        pagingSelectorControl1.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(view)
        }
        
        pagingSelectorControl1.layoutSubviews()
        
        let pagingSelectorControl2 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name])
        pagingSelectorControl2.tabTextColor = UIColor.whiteColor()

        view.addSubview(pagingSelectorControl2);
        pagingSelectorControl2.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(pagingSelectorControl1.snp_bottom)
        }

        let pagingSelectorControl3 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name], tabWidth: 90)
        pagingSelectorControl3.tabTextColor = UIColor.cyanColor()
        
        view.addSubview(pagingSelectorControl3);
        pagingSelectorControl3.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(pagingSelectorControl2.snp_bottom)
        }
        
        let pagingSelectorControl4 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name, tab4Name], tabWidth: 90)
        pagingSelectorControl4.tabTextColor = UIColor.lightGrayColor()
        
        view.addSubview(pagingSelectorControl4);
        pagingSelectorControl4.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(pagingSelectorControl3.snp_bottom)
        }

        let pagingSelectorControl5 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name, tab4Name, tab5Name], tabWidth: 90)
        pagingSelectorControl5.tabTextColor = UIColor.blackColor()
        
        view.addSubview(pagingSelectorControl5);
        pagingSelectorControl5.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(pagingSelectorControl4.snp_bottom)
        }
        
        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

