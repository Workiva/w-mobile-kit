//
//  WMobileKitUserLogoExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class WMobileKitUserLogoExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let userLogo = WUserLogoView("Jessica Jones")
        view.addSubview(userLogo)
        userLogo.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-50)
            make.top.equalTo(view).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel)
        userLogoLabel.text = userLogo.name
        userLogoLabel.textAlignment = .Right
        userLogoLabel.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo.snp_left).offset(-10)
            make.centerY.equalTo(userLogo)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo2 = WUserLogoView("Steve Rogers")
        view.addSubview(userLogo2)
        userLogo2.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo.snp_bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        let userLogoLabel2 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel2)
        userLogoLabel2.text = userLogo2.name
        userLogoLabel2.textAlignment = .Right
        userLogoLabel2.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo2.snp_left).offset(-10)
            make.centerY.equalTo(userLogo2)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo3 = WUserLogoView("Natasha Romanova")
        view.addSubview(userLogo3)
        userLogo3.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo2.snp_bottom).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel3 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel3)
        userLogoLabel3.text = userLogo3.name
        userLogoLabel3.textAlignment = .Right
        userLogoLabel3.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo3.snp_left).offset(-10)
            make.centerY.equalTo(userLogo3)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo4 = WUserLogoView("Anthony Edward Stark")
        view.addSubview(userLogo4)
        userLogo4.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo3.snp_bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        let userLogoLabel4 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel4)
        userLogoLabel4.text = userLogo4.name
        userLogoLabel4.textAlignment = .Right
        userLogoLabel4.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo4.snp_left).offset(-10)
            make.centerY.equalTo(userLogo4)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo5 = WUserLogoView("Peter Benjamin Parker")
        view.addSubview(userLogo5)
        userLogo5.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo4.snp_bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        let userLogoLabel5 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel5)
        userLogoLabel5.text = userLogo5.name
        userLogoLabel5.textAlignment = .Right
        userLogoLabel5.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo5.snp_left).offset(-10)
            make.centerY.equalTo(userLogo5)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo6 = WUserLogoView("Scott Summers")
        view.addSubview(userLogo6)
        userLogo6.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo5.snp_bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        let userLogoLabel6 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel6)
        userLogoLabel6.text = userLogo6.name
        userLogoLabel6.textAlignment = .Right
        userLogoLabel6.snp_makeConstraints { (make) in
            make.right.equalTo(userLogo6.snp_left).offset(-10)
            make.centerY.equalTo(userLogo6)
            make.left.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo7 = WUserLogoView("Jean Grey")
        view.addSubview(userLogo7)
        userLogo7.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(50)
            make.centerY.equalTo(userLogo)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel7 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel7)
        userLogoLabel7.text = userLogo7.name
        userLogoLabel7.snp_makeConstraints { (make) in
            make.left.equalTo(userLogo7.snp_right).offset(10)
            make.centerY.equalTo(userLogo7)
            make.right.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo8 = WUserLogoView("Matt Murdock")
        view.addSubview(userLogo8)
        userLogo8.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo7)
            make.centerY.equalTo(userLogo2)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel8 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel8)
        userLogoLabel8.text = userLogo8.name
        userLogoLabel8.snp_makeConstraints { (make) in
            make.left.equalTo(userLogo8.snp_right).offset(10)
            make.centerY.equalTo(userLogo8)
            make.right.equalTo(view)
            make.height.equalTo(20)
        }
        
        let userLogo9 = WUserLogoView("Gambit")
        view.addSubview(userLogo9)
        userLogo9.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo7)
            make.centerY.equalTo(userLogo3)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        let userLogoLabel9 = UILabel(frame: CGRectZero)
        view.addSubview(userLogoLabel9)
        userLogoLabel9.text = userLogo9.name
        userLogoLabel9.snp_makeConstraints { (make) in
            make.left.equalTo(userLogo9.snp_right).offset(10)
            make.centerY.equalTo(userLogo9)
            make.right.equalTo(view)
            make.height.equalTo(20)
        }
        
        view.layoutIfNeeded()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

