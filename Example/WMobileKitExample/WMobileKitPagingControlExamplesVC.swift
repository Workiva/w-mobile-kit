//
//  WMobileKitPagingControlExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class WMobileKitPagingControlExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let tabLayout = WPagingSelectorControl(titles: ["Recent", "All Files"])

        view.addSubview(tabLayout);
        tabLayout.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(view)
        }

        tabLayout.layoutSubviews()

        let tabLayout2 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"])

        view.addSubview(tabLayout2);
        tabLayout2.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout.snp_bottom)
        }

        tabLayout2.layoutSubviews()

        let tabLayout3 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots"], tabWidth: 90)

        view.addSubview(tabLayout3);
        tabLayout3.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout2.snp_bottom)
        }

        tabLayout3.layoutSubviews()

        let tabLayout4 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff"], tabWidth: 90)

        view.addSubview(tabLayout4);
        tabLayout4.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout3.snp_bottom)
        }

        tabLayout4.layoutSubviews()

        let tabLayout5 = WPagingSelectorControl(titles: ["Recent", "All Files", "Snapshots", "Cool stuff", "Too many"], tabWidth: 90)

        view.addSubview(tabLayout5);
        tabLayout5.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout4.snp_bottom)
        }

        tabLayout5.layoutSubviews()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

