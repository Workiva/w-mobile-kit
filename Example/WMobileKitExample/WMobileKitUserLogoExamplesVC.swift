//
//  WMobileKitUserLogoExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class WMobileKitUserLogoExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let userLogo = WUserLogo(frame: CGRectZero)
        view.addSubview(userLogo)
        userLogo.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-80)
            make.centerY.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
//        userLogo.setupUI()
        
        let userLogo2 = WUserLogo(frame: CGRectZero)
        view.addSubview(userLogo2)
        userLogo2.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(80)
            make.centerY.equalTo(view)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
//        userLogo2.setupUI()
        
        userLogo.initials = "JR"
        
        userLogo2.initials = "FU"
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

