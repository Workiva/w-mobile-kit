//
//  UserLogoViewExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class UserLogoViewExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        let scrollView = UIScrollView(frame: CGRectZero)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        let userLogo = WUserLogoView("Jessica Jones 1 1 1 1")
        userLogo.initialsLimit = 2
        scrollView.addSubview(userLogo)
        userLogo.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView).dividedBy(2)
            make.top.equalTo(scrollView).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel = UILabel()
        scrollView.addSubview(userLogoLabel)
        userLogoLabel.text = userLogo.name
        userLogoLabel.textAlignment = .Center
        userLogoLabel.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo2 = WUserLogoView("Steve Rogers")
        scrollView.addSubview(userLogo2)
        userLogo2.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo.snp_bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        let userLogoLabel2 = UILabel()
        scrollView.addSubview(userLogoLabel2)
        userLogoLabel2.text = userLogo2.name
        userLogoLabel2.textAlignment = .Center
        userLogoLabel2.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo2.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo3 = WUserLogoView("Natasha Romanova")
        scrollView.addSubview(userLogo3)
        userLogo3.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo2.snp_bottom).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel3 = UILabel()
        scrollView.addSubview(userLogoLabel3)
        userLogoLabel3.text = userLogo3.name
        userLogoLabel3.textAlignment = .Center
        userLogoLabel3.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo3.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo4 = WUserLogoView("Anthony Edward Stark")
        userLogo4.initialsLimit = 2
        userLogo4.initials = "AS"
        scrollView.addSubview(userLogo4)
        userLogo4.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo3.snp_bottom).offset(30)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        let userLogoLabel4 = UILabel()
        scrollView.addSubview(userLogoLabel4)
        userLogoLabel4.text = userLogo4.name
        userLogoLabel4.textAlignment = .Center
        userLogoLabel4.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo4.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo5 = WUserLogoView("Peter Benjamin Parker")
        scrollView.addSubview(userLogo5)
        userLogo5.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo4.snp_bottom).offset(30)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        let userLogoLabel5 = UILabel()
        scrollView.addSubview(userLogoLabel5)
        userLogoLabel5.text = userLogo5.name
        userLogoLabel5.textAlignment = .Center
        userLogoLabel5.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo5.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo6 = WUserLogoView("Scott Summers")
        scrollView.addSubview(userLogo6)
        userLogo6.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo5.snp_bottom).offset(30)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        let userLogoLabel6 = UILabel()
        scrollView.addSubview(userLogoLabel6)
        userLogoLabel6.text = userLogo6.name
        userLogoLabel6.textAlignment = .Center
        userLogoLabel6.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView.snp_centerX).offset(-10)
            make.top.equalTo(userLogo6.snp_bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }
        
        let userLogo7 = WUserLogoView("Jean Grey")
        scrollView.addSubview(userLogo7)
        userLogo7.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView).multipliedBy(1.5)
            make.centerY.equalTo(userLogo)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel7 = UILabel()
        scrollView.addSubview(userLogoLabel7)
        userLogoLabel7.text = userLogo7.name
        userLogoLabel7.textAlignment = .Center
        userLogoLabel7.snp_makeConstraints { (make) in
            make.left.equalTo(scrollView.snp_centerX).offset(10)
            make.top.equalTo(userLogo7.snp_bottom)
            make.right.equalTo(scrollView)
            make.height.equalTo(20)
        }
        
        let userLogo8 = WUserLogoView("Matt Murdock")
        scrollView.addSubview(userLogo8)
        userLogo8.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo7)
            make.centerY.equalTo(userLogo2)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        let userLogoLabel8 = UILabel()
        scrollView.addSubview(userLogoLabel8)
        userLogoLabel8.text = userLogo8.name
        userLogoLabel8.textAlignment = .Center
        userLogoLabel8.snp_makeConstraints { (make) in
            make.left.equalTo(scrollView.snp_centerX).offset(10)
            make.top.equalTo(userLogo8.snp_bottom)
            make.right.equalTo(scrollView)
            make.height.equalTo(20)
        }
        
        let userLogo9 = WUserLogoView("Gambit The X Man")
        userLogo9.initialsLimit = 1
        scrollView.addSubview(userLogo9)
        userLogo9.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo7)
            make.centerY.equalTo(userLogo3)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        let userLogoLabel9 = UILabel()
        scrollView.addSubview(userLogoLabel9)
        userLogoLabel9.text = userLogo9.name
        userLogoLabel9.textAlignment = .Center
        userLogoLabel9.snp_makeConstraints { (make) in
            make.left.equalTo(scrollView.snp_centerX).offset(10)
            make.top.equalTo(userLogo9.snp_bottom)
            make.right.equalTo(scrollView)
            make.height.equalTo(20)
        }
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: userLogoLabel6.frame.origin.y + userLogoLabel6.frame.size.height)
        scrollView.scrollEnabled = true
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

