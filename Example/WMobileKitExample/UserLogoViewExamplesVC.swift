//
//  UserLogoViewExamplesVC.swift
//  WMobileKitExample
//
//  Copyright 2016 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import WMobileKit

public class UserLogoViewExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let verticalSpacing = 12

        let name1 = "Jessica Jones 1 2 3 4"
        let name2 = "Steve Rogers"
        let name3 = "Natasha Romanova"
        let name4 = "Jean Grey Phoenix"
        let name5 = "Peter Benj Parker"
        let name6 = ""
        let name7 = "Matt Murdock"
        let name8 = "Gambit X-Man"
        let name9 = "Scott Summers"
        let name10 = "Anthony Ed Stark"
        let name11 = "Homer Simpson"

        let scrollView = UIScrollView(frame: CGRectZero)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        let userLogo = WUserLogoView(name1)
        userLogo.initialsLimit = 2
        scrollView.addSubview(userLogo)
        userLogo.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView).dividedBy(2)
            make.top.equalTo(scrollView).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
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
        
        let userLogo2 = WUserLogoView(name2)
        scrollView.addSubview(userLogo2)
        userLogo2.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel.snp_bottom).offset(verticalSpacing)
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
        
        let userLogo3 = WUserLogoView(name3)
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
        
        let userLogo4 = WUserLogoView(name4)
        userLogo4.initialsLimit = 2
        userLogo4.initials = "AS"
        scrollView.addSubview(userLogo4)
        userLogo4.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel3.snp_bottom).offset(verticalSpacing)
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
        
        let userLogo5 = WUserLogoView(name5)
        scrollView.addSubview(userLogo5)
        userLogo5.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel4.snp_bottom).offset(verticalSpacing)
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
        
        let userLogo6 = WUserLogoView(name6)
        userLogo6.initialsLimit = 2
        scrollView.addSubview(userLogo6)
        userLogo6.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView).multipliedBy(1.5)
            make.top.equalTo(scrollView).offset(verticalSpacing)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        let userLogoLabel6 = UILabel()
        scrollView.addSubview(userLogoLabel6)
        userLogoLabel6.text = userLogo6.name
        userLogoLabel6.textAlignment = .Center
        userLogoLabel6.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo6.snp_bottom)
            make.centerX.equalTo(userLogo6)
            make.height.equalTo(0)
        }
        
        let userLogo7 = WUserLogoView(name7)
        scrollView.addSubview(userLogo7)
        userLogo7.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel6.snp_bottom).offset(verticalSpacing)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        let userLogoLabel7 = UILabel()
        scrollView.addSubview(userLogoLabel7)
        userLogoLabel7.text = userLogo7.name
        userLogoLabel7.textAlignment = .Center
        userLogoLabel7.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo7.snp_bottom)
            make.centerX.equalTo(userLogo7)
            make.height.equalTo(20)
        }
        
        let userLogo8 = WUserLogoView(name8)
        userLogo8.initialsLimit = 1
        scrollView.addSubview(userLogo8)
        userLogo8.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel7.snp_bottom).offset(verticalSpacing)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        let userLogoLabel8 = UILabel()
        scrollView.addSubview(userLogoLabel8)
        userLogoLabel8.text = userLogo8.name
        userLogoLabel8.textAlignment = .Center
        userLogoLabel8.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo8.snp_bottom)
            make.centerX.equalTo(userLogo8)
            make.height.equalTo(20)
        }

        let userLogo9 = WUserLogoView(name9)
        userLogo9.initialsLimit = 1
        scrollView.addSubview(userLogo9)
        userLogo9.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel8.snp_bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel9 = UILabel()
        scrollView.addSubview(userLogoLabel9)
        userLogoLabel9.text = userLogo9.name
        userLogoLabel9.textAlignment = .Center
        userLogoLabel9.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo9.snp_bottom)
            make.centerX.equalTo(userLogo9)
            make.height.equalTo(20)
        }

        let userLogo10 = WUserLogoView(name10)
        userLogo10.initialsLimit = 1
        scrollView.addSubview(userLogo10)
        userLogo10.snp_makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel9.snp_bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel10 = UILabel()
        scrollView.addSubview(userLogoLabel10)
        userLogoLabel10.text = userLogo10.name
        userLogoLabel10.textAlignment = .Center
        userLogoLabel10.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo10.snp_bottom)
            make.centerX.equalTo(userLogo10)
            make.height.equalTo(20)
        }
        
        let userLogo11 = WUserLogoView(name11)
        userLogo11.initialsLimit = 2
        userLogo11.imageURL = "http://www.simpsoncrazy.com/content/pictures/homer/HomerSimpson3.gif"
        userLogo11.lineWidth = 2
        scrollView.addSubview(userLogo11)
        userLogo11.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(userLogoLabel5.snp_bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        let userLogoLabel11 = UILabel()
        scrollView.addSubview(userLogoLabel11)
        userLogoLabel11.text = userLogo11.name
        userLogoLabel11.textAlignment = .Center
        userLogoLabel11.snp_makeConstraints { (make) in
            make.top.equalTo(userLogo11.snp_bottom)
            make.centerX.equalTo(userLogo11)
            make.height.equalTo(20)
        }
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: userLogoLabel5.frame.origin.y + userLogoLabel5.frame.size.height)
        scrollView.scrollEnabled = true
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

