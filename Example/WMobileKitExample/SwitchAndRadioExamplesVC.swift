//
//  SwitchAndRadioExamplesVC.swift
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

open class SwitchAndRadioExamplesVC: WSideMenuContentVC {
    let switch1 = WSwitch()
    let switch2 = WSwitch(false)

    let switchLabel1 = UILabel()
    let switchLabel2 = UILabel()

    @IBOutlet var storyboardSwitch: WSwitch!
    @IBOutlet var storyboardLabel: UILabel!

    // Group 1
    let radio1 = WRadioButton()
    let radio2 = WRadioButton()
    let radio3 = WRadioButton()
    let radio4 = WRadioButton()

    // Group 2
    let radio5 = WRadioButton()
    let radio6 = WRadioButton()
    let radio7 = WRadioButton()
    let radio8 = WRadioButton()

    // Group 3
    @IBOutlet var storyboardRadio1: WRadioButton!
    @IBOutlet var storyboardRadio2: WRadioButton!
    @IBOutlet var storyboardRadio3: WRadioButton!
    @IBOutlet var storyboardRadio4: WRadioButton!

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Switches
        view.addSubview(switch1)
        switch1.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(250)
        }
        switch1.tag = 1
        switch1.barWidth = 100
        switch1.barHeight = 20
        switch1.circleRadius = 18.0
        switch1.frontCircle.backgroundColor = .yellow
        switch1.backCircle.backgroundColor = .lightGray
        switch1.barView.backgroundColor = .cyan

        view.addSubview(switchLabel1)
        switchLabel1.snp.makeConstraints { (make) in
            make.centerY.equalTo(switch1)
            make.right.equalTo(switch1.snp.left).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        switchLabel1.text = "On"
        switchLabel1.textAlignment = .right
        
        view.addSubview(switch2)
        switch2.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(switch1.snp.bottom).offset(20)
        }
        switch2.tag = 2
        switch2.barHeight = 30
        switch2.barWidth = 40
        switch2.circleRadius = 12.0
        switch2.frontCircle.backgroundColor = .green
        switch2.backCircle.backgroundColor = .purple
        switch2.barView.backgroundColor = .white
        
        view.addSubview(switchLabel2)
        switchLabel2.snp.makeConstraints { (make) in
            make.centerY.equalTo(switch2)
            make.right.equalTo(switch2.snp.left).offset(-10)
            make.left.equalTo(view).offset(10)
        }

        switchLabel2.text = "Off"
        switchLabel2.textAlignment = .right

        switch1.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchValueChanged(_:)), for: .valueChanged)
        switch2.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchValueChanged(_:)), for: .valueChanged)

        // Radio Buttons
        // Group1
        view.addSubview(radio2)
        radio2.snp.makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-20)
            make.top.equalTo(switch2.snp.bottom).offset(25)
        }
        radio2.buttonID = 2
        radio2.groupID = 1
        radio2.isSelected = true

        view.addSubview(radio1)
        radio1.snp.makeConstraints { (make) in
            make.top.equalTo(radio2.snp.top)
            make.right.equalTo(radio2.snp.left).offset(-10)
        }
        radio1.buttonID = 1
        radio1.groupID = 1

        view.addSubview(radio3)
        radio3.snp.makeConstraints { (make) in
            make.top.equalTo(radio2.snp.top)
            make.left.equalTo(radio2.snp.right).offset(10)
        }
        radio3.buttonID = 3
        radio3.groupID = 1

        view.addSubview(radio4)
        radio4.snp.makeConstraints { (make) in
            make.top.equalTo(radio2.snp.top)
            make.left.equalTo(radio3.snp.right).offset(10)
        }
        radio4.buttonID = 4
        radio4.groupID = 1

        // Group2
        view.addSubview(radio6)
        radio6.snp.makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-20)
            make.top.equalTo(radio2.snp.bottom).offset(25)
        }
        radio6.buttonID = 6
        radio6.groupID = 2
        radio6.buttonRadius = 20
        radio6.borderWidth = 5

        radio6.borderColorSelected = .red
        radio6.highlightColor = .blue
        radio6.indicatorColor = .red

        radio6.indicatorRadius = 8
        radio6.isSelected = true

        view.addSubview(radio5)
        radio5.snp.makeConstraints { (make) in
            make.top.equalTo(radio6.snp.top)
            make.right.equalTo(radio6.snp.left).offset(-10)
        }
        radio5.buttonID = 5
        radio5.groupID = 2
        radio5.indicatorColor = .blue
        radio5.indicatorRadius = 9
        radio5.buttonRadius = 20
        radio5.buttonColor = .yellow
        radio5.borderWidth = 5

        radio5.borderColorSelected = .purple
        radio5.highlightColor = .black

        view.addSubview(radio7)
        radio7.snp.makeConstraints { (make) in
            make.top.equalTo(radio6.snp.top)
            make.left.equalTo(radio6.snp.right).offset(10)
        }
        radio7.buttonID = 7
        radio7.groupID = 2
        radio7.buttonRadius = 20
        radio7.borderWidth = 5

        radio7.borderColorSelected = .blue
        radio7.highlightColor = .red
        radio7.indicatorColor = .magenta

        radio7.indicatorRadius = 7

        view.addSubview(radio8)
        radio8.snp.makeConstraints { (make) in
            make.top.equalTo(radio6.snp.top)
            make.left.equalTo(radio7.snp.right).offset(10)
        }
        radio8.buttonID = 8
        radio8.groupID = 2
        radio8.buttonRadius = 20
        radio8.buttonColor = .lightGray
        radio8.borderWidth = 5

        radio8.borderColorSelected = .green
        radio8.highlightColor = .yellow
        radio8.indicatorColor = .black

        radio8.indicatorRadius = 6

        // Group3: Storyboard group
        storyboardRadio1.buttonID = 9
        storyboardRadio1.groupID = 3
        storyboardRadio1.isSelected = true

        storyboardRadio2.buttonID = 10
        storyboardRadio2.groupID = 3

        storyboardRadio3.buttonID = 11
        storyboardRadio3.groupID = 3

        storyboardRadio4.buttonID = 12
        storyboardRadio4.groupID = 3

        view.layoutIfNeeded()
    }
    
    @IBAction func storyboardSwitchValueChanged(_ sender: WSwitch) {
        storyboardLabel.text = sender.on ? "On" : "Off"
    }
    
    @objc open func switchValueChanged(_ sender: WSwitch) {
        switch sender.tag {
        case 1:
            switchLabel1.text = sender.on ? "On" : "Off"
        case 2:
            switchLabel2.text = sender.on ? "On" : "Off"
        default:
            break
        }
    }
}
