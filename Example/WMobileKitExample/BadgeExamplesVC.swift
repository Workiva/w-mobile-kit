//
//  BadgeExamplesVC.swift
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

public class BadgeExamplesVC: WSideMenuContentVC {
    @IBOutlet var storyboardAutoHideBadge: WBadge!
    @IBOutlet var storyboardBadge: WBadge!
    @IBOutlet var storyboardLocationBadge: WBadge!

    @IBAction func valueChanged(sender: UIStepper) {
        storyboardAutoHideBadge.count = Int(sender.value)
        storyboardBadge.count = Int(sender.value)
        storyboardLocationBadge.count = Int(sender.value)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Storyboard
        storyboardAutoHideBadge.verticalAlignment = .Center
        storyboardAutoHideBadge.horizontalAlignment = .Center

        storyboardBadge.automaticallyHide = false
        storyboardBadge.verticalAlignment = .Center
        storyboardBadge.horizontalAlignment = .Center

        storyboardLocationBadge.verticalAlignment = .Bottom
        storyboardLocationBadge.horizontalAlignment = .Left
        storyboardLocationBadge.showValue = false

        // Defaults
        let badge1 = WBadge()
        badge1.count = 1
        view.addSubview(badge1)
        badge1.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-60)
            make.top.equalTo(view).offset(200)
        }

        let label1 = UILabel()
        label1.text = "Default:"
        label1.sizeToFit()
        view.addSubview(label1)
        label1.snp_makeConstraints { (make) in
            make.right.equalTo(badge1.snp_left).offset(-4)
            make.top.equalTo(badge1.snp_top).offset(-2)
        }

        let badge2 = WBadge()
        view.addSubview(badge2)
        badge2.snp_makeConstraints { (make) in
            make.left.equalTo(badge1.snp_right).offset(4)
            make.top.equalTo(badge1.snp_top)
        }
        badge2.count = 67

        let badge3 = WBadge(111)
        view.addSubview(badge3)
        badge3.snp_makeConstraints { (make) in
            make.left.equalTo(badge2.snp_right).offset(4)
            make.top.equalTo(badge2.snp_top)
        }

        let badge4 = WBadge(576937839)
        view.addSubview(badge4)
        badge4.snp_makeConstraints { (make) in
            make.left.equalTo(badge3.snp_right).offset(4)
            make.top.equalTo(badge3.snp_top)
        }

        // Will be hidden since < 1
        let badge5 = WBadge(-9)
        view.addSubview(badge5)
        badge5.snp_makeConstraints { (make) in
            make.left.equalTo(badge4.snp_right).offset(4)
            make.top.equalTo(badge4.snp_top)
        }

        // Custom
        let badge6 = WBadge()
        badge6.count = 1
        badge6.badgeColor = .redColor()
        badge6.countColor = .yellowColor()
        badge6.widthPadding = 10.0
        badge6.heightPadding = 5.0
        badge6.fontSize = 11.0
        badge6.cornerRadius = 17.0
        view.addSubview(badge6)
        badge6.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-60)
            make.top.equalTo(badge1.snp_bottom).offset(20)
        }

        let label2 = UILabel()
        label2.text = "Custom:"
        label2.sizeToFit()
        view.addSubview(label2)
        label2.snp_makeConstraints { (make) in
            make.right.equalTo(badge6.snp_left).offset(-4)
            make.centerY.equalTo(badge6.snp_centerY)
        }

        let badge7 = WBadge(67)
        badge7.badgeColor = .greenColor()
        badge7.countColor = .lightGrayColor()
        badge7.widthPadding = 10.0
        badge7.heightPadding = 10.0
        badge7.fontSize = 15.0
        badge7.cornerRadius = 15.0
        view.addSubview(badge7)
        badge7.snp_makeConstraints { (make) in
            make.left.equalTo(badge6.snp_right).offset(4)
            make.centerY.equalTo(badge6.snp_centerY)
        }

        let badge8 = WBadge(111)
        badge8.badgeColor = .yellowColor()
        badge8.countColor = .blackColor()
        badge8.widthPadding = 0
        badge8.heightPadding = 0
        badge8.fontSize = 10.0
        badge8.cornerRadius = 0
        view.addSubview(badge8)
        badge8.snp_makeConstraints { (make) in
            make.left.equalTo(badge7.snp_right).offset(4)
            make.centerY.equalTo(badge6.snp_centerY)
        }

        let badge9 = WBadge(576937839)
        badge9.badgeColor = .cyanColor()
        badge9.countColor = .purpleColor()
        badge9.widthPadding = 20
        badge9.heightPadding = 0
        badge9.fontSize = 8.0
        badge9.cornerRadius = 20
        view.addSubview(badge9)
        badge9.snp_makeConstraints { (make) in
            make.left.equalTo(badge8.snp_right).offset(4)
            make.centerY.equalTo(badge6.snp_centerY)
        }

        let badge10 = WBadge(-9)
        badge10.badgeColor = .blackColor()
        badge10.countColor = .cyanColor()
        badge10.widthPadding = 0
        badge10.heightPadding = 20
        badge10.fontSize = 12.0
        badge10.cornerRadius = 20
        badge10.automaticallyHide = false
        view.addSubview(badge10)
        badge10.snp_makeConstraints { (make) in
            make.left.equalTo(badge9.snp_right).offset(4)
            make.centerY.equalTo(badge6.snp_centerY)
        }
        
        view.layoutIfNeeded()
    }
}