//
//  RadioAndSwitchExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class SwitchAndRadioExamplesVC: WSideMenuContentVC {
    let switch1 = WSwitch()
    let switch2 = WSwitch(false)
    
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()

    let radio1 = WRadioButton()
    let radio2 = WRadioButton()
    let radio3 = WRadioButton()
    let radio4 = WRadioButton()

    @IBOutlet var storyboardSwitch: WSwitch!
    @IBOutlet var storyboardLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Switches
        view.addSubview(switch1)
        switch1.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(210)
        }
        switch1.tag = 1
        
        view.addSubview(label1)
        label1.snp_makeConstraints { (make) in
            make.centerY.equalTo(switch1)
            make.right.equalTo(switch1.snp_left).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        label1.text = "On"
        label1.textAlignment = .Right
        
        view.addSubview(switch2)
        switch2.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(switch1.snp_bottom).offset(10)
        }
        switch2.tag = 2
        
        view.addSubview(label2)
        label2.snp_makeConstraints { (make) in
            make.centerY.equalTo(switch2)
            make.right.equalTo(switch2.snp_left).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        label2.text = "Off"
        label2.textAlignment = .Right

        // Radio Buttons
        view.addSubview(radio2)
        radio2.snp_makeConstraints { (make) in
            make.centerX.equalTo(view).offset(-20)
            make.top.equalTo(switch2.snp_bottom).offset(50)
        }
        radio2.tag = 2
        radio2.groupID = 1
        radio2.selected = true

        view.addSubview(radio1)
        radio1.snp_makeConstraints { (make) in
            make.top.equalTo(radio2.snp_top)
            make.right.equalTo(radio2.snp_left).offset(-10)
        }
        radio1.tag = 1
        radio1.groupID = 1

        view.addSubview(radio3)
        radio3.snp_makeConstraints { (make) in
            make.top.equalTo(radio2.snp_top)
            make.left.equalTo(radio2.snp_right).offset(10)
        }
        radio3.tag = 3
        radio3.groupID = 1

        view.addSubview(radio4)
        radio4.snp_makeConstraints { (make) in
            make.top.equalTo(radio2.snp_top)
            make.left.equalTo(radio3.snp_right).offset(10)
        }
        radio4.tag = 4
        radio4.groupID = 1
        
        view.layoutIfNeeded()
        
        switch1.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchValueChanged(_:)), forControlEvents: .ValueChanged)
        switch2.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    @IBAction func storyboardSwitchValueChanged(sender: WSwitch) {
        storyboardLabel.text = sender.on ? "On" : "Off"
    }
    
    public func switchValueChanged(sender: WSwitch) {
        switch sender.tag {
        case 1:
            label1.text = sender.on ? "On" : "Off"
        case 2:
            label2.text = sender.on ? "On" : "Off"
        default:
            break
        }
    }
}