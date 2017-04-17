//
//  UserLogoViewExamplesVC.swift
//  WMobileKitExample
//
//  Copyright 2017 Workiva Inc.
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

open class UserLogoViewExamplesVC: WSideMenuContentVC {
    open override func viewDidLoad() {
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
        let name11 = "Workiva"

        let scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }

        let userLogo = WUserLogoView(name: name1)
        userLogo.initialsLimit = 2
        scrollView.addSubview(userLogo)
        userLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView).dividedBy(2)
            make.top.equalTo(scrollView).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel = UILabel()
        scrollView.addSubview(userLogoLabel)
        userLogoLabel.text = userLogo.name
        userLogoLabel.textAlignment = .center
        userLogoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.top.equalTo(userLogo.snp.bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }

        let userLogo2 = WUserLogoView(name: name2)
        scrollView.addSubview(userLogo2)
        userLogo2.type = .Filled
        userLogo2.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        let userLogoLabel2 = UILabel()
        scrollView.addSubview(userLogoLabel2)
        userLogoLabel2.text = userLogo2.name
        userLogoLabel2.textAlignment = .center
        userLogoLabel2.snp.makeConstraints { (make) in
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.top.equalTo(userLogo2.snp.bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }

        let userLogo3 = WUserLogoView(name: name3)
        scrollView.addSubview(userLogo3)
        userLogo3.shape = .Square
        userLogo3.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogo2.snp.bottom).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }

        let userLogoLabel3 = UILabel()
        scrollView.addSubview(userLogoLabel3)
        userLogoLabel3.text = userLogo3.name
        userLogoLabel3.textAlignment = .center
        userLogoLabel3.snp.makeConstraints { (make) in
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.top.equalTo(userLogo3.snp.bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }

        let userLogo4 = WUserLogoView(name: name4)
        userLogo4.initialsLimit = 2
        userLogo4.type = .Filled
        scrollView.addSubview(userLogo4)
        userLogo4.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel3.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        let userLogoLabel4 = UILabel()
        scrollView.addSubview(userLogoLabel4)
        userLogoLabel4.text = userLogo4.name
        userLogoLabel4.textAlignment = .center
        userLogoLabel4.snp.makeConstraints { (make) in
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.top.equalTo(userLogo4.snp.bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }

        let userLogo5 = WUserLogoView(name: name5)
        scrollView.addSubview(userLogo5)
        userLogo5.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo)
            make.top.equalTo(userLogoLabel4.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }

        let userLogoLabel5 = UILabel()
        scrollView.addSubview(userLogoLabel5)
        userLogoLabel5.text = userLogo5.name
        userLogoLabel5.textAlignment = .center
        userLogoLabel5.snp.makeConstraints { (make) in
            make.right.equalTo(scrollView.snp.centerX).offset(-10)
            make.top.equalTo(userLogo5.snp.bottom)
            make.left.equalTo(scrollView).offset(10)
            make.height.equalTo(20)
        }

        let userLogo6 = WUserLogoView(name: name6)
        userLogo6.initialsLimit = 2
        scrollView.addSubview(userLogo6)
        userLogo6.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView).multipliedBy(1.5)
            make.top.equalTo(scrollView).offset(verticalSpacing)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }

        let userLogoLabel6 = UILabel()
        scrollView.addSubview(userLogoLabel6)
        userLogoLabel6.text = userLogo6.name
        userLogoLabel6.textAlignment = .center
        userLogoLabel6.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo6.snp.bottom)
            make.centerX.equalTo(userLogo6)
            make.height.equalTo(0)
        }

        let userLogo7 = WUserLogoView(name: name7)
        scrollView.addSubview(userLogo7)
        userLogo7.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel6.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        let userLogoLabel7 = UILabel()
        scrollView.addSubview(userLogoLabel7)
        userLogoLabel7.text = userLogo7.name
        userLogoLabel7.textAlignment = .center
        userLogoLabel7.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo7.snp.bottom)
            make.centerX.equalTo(userLogo7)
            make.height.equalTo(20)
        }

        let userLogo8 = WUserLogoView(name: name8)
        userLogo8.initialsLimit = 1
        userLogo8.shape = .Square
        userLogo8.type = .Filled
        scrollView.addSubview(userLogo8)
        userLogo8.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel7.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        let userLogoLabel8 = UILabel()
        scrollView.addSubview(userLogoLabel8)
        userLogoLabel8.text = userLogo8.name
        userLogoLabel8.textAlignment = .center
        userLogoLabel8.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo8.snp.bottom)
            make.centerX.equalTo(userLogo8)
            make.height.equalTo(20)
        }

        let userLogo9 = WUserLogoView(name: name9)
        userLogo9.initialsLimit = 1
        scrollView.addSubview(userLogo9)
        userLogo9.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel8.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel9 = UILabel()
        scrollView.addSubview(userLogoLabel9)
        userLogoLabel9.text = userLogo9.name
        userLogoLabel9.textAlignment = .center
        userLogoLabel9.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo9.snp.bottom)
            make.centerX.equalTo(userLogo9)
            make.height.equalTo(20)
        }

        let userLogo10 = WUserLogoView(name: name10)
        userLogo10.initialsLimit = 1
        scrollView.addSubview(userLogo10)
        userLogo10.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo6)
            make.top.equalTo(userLogoLabel9.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel10 = UILabel()
        scrollView.addSubview(userLogoLabel10)
        userLogoLabel10.text = userLogo10.name
        userLogoLabel10.textAlignment = .center
        userLogo10.initials = "AS"
        userLogoLabel10.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo10.snp.bottom)
            make.centerX.equalTo(userLogo10)
            make.height.equalTo(20)
        }

        let userLogo11 = WUserLogoView(name: name11)
        userLogo11.initialsLimit = 2
        userLogo11.imageURL = "https://avatars0.githubusercontent.com/u/1087529?v=3&s=200"
        userLogo11.lineWidth = 2
        scrollView.addSubview(userLogo11)
        userLogo11.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo5)
            make.top.equalTo(userLogoLabel5.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel11 = UILabel()
        scrollView.addSubview(userLogoLabel11)
        userLogoLabel11.text = userLogo11.name
        userLogoLabel11.textAlignment = .center
        userLogoLabel11.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo11.snp.bottom)
            make.centerX.equalTo(userLogo11)
            make.height.equalTo(20)
        }

        let userLogo12 = WUserLogoView(name: name11)
        userLogo12.initialsLimit = 2
        userLogo12.imageURL = "https://avatars0.githubusercontent.com/u/1087529?v=3&s=200"
        userLogo12.lineWidth = 2
        userLogo12.shape = .Square
        scrollView.addSubview(userLogo12)
        userLogo12.snp.makeConstraints { (make) in
            make.centerX.equalTo(userLogo10)
            make.top.equalTo(userLogoLabel5.snp.bottom).offset(verticalSpacing)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }

        let userLogoLabel12 = UILabel()
        scrollView.addSubview(userLogoLabel12)
        userLogoLabel12.text = userLogo11.name
        userLogoLabel12.textAlignment = .center
        userLogoLabel12.snp.makeConstraints { (make) in
            make.top.equalTo(userLogo12.snp.bottom)
            make.centerX.equalTo(userLogo12)
            make.height.equalTo(20)
        }

        view.layoutIfNeeded()

        scrollView.contentSize = CGSize(width: view.frame.width, height: userLogoLabel11.frame.origin.y + userLogoLabel11.frame.size.height + 10)
        scrollView.isScrollEnabled = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

