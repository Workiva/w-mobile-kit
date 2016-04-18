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

        let tabLayout1 = WPagingSelectorControl(titles: [tab1Name, tab2Name])
        
        view.addSubview(tabLayout1);
        tabLayout1.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(view)
        }
        
        tabLayout1.layoutSubviews()
        tabLayout1.tabTextColor = UIColor.redColor()
        
        let tabLayout2 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name])

        view.addSubview(tabLayout2);
        tabLayout2.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout1.snp_bottom)
        }

        let tabLayout3 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name], tabWidth: 90)
        
        view.addSubview(tabLayout3);
        tabLayout3.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout2.snp_bottom)
        }
        
        let tabLayout4 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name, tab4Name], tabWidth: 90)
        
        view.addSubview(tabLayout4);
        tabLayout4.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout3.snp_bottom)
        }

        let tabLayout5 = WPagingSelectorControl(titles: [tab1Name, tab2Name, tab3Name, tab4Name, tab5Name], tabWidth: 90)
        
        view.addSubview(tabLayout5);
        tabLayout5.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(DEFAULT_PAGING_SELECTOR_HEIGHT)
            make.top.equalTo(tabLayout4.snp_bottom)
        }
        
        view.layoutIfNeeded()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

