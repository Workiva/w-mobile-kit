//
//  RadioAndSwitchExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class SwitchAndRadioExamplesVC: WSideMenuContentVC {
    let switch1 = WSwitch(true)
    let switch2 = WSwitch(false)
    let switch3 = WSwitch(true)
    
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(switch1)
        switch1.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(240)
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
            make.top.equalTo(switch1.snp_bottom).offset(20)
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
        
        view.addSubview(switch3)
        switch3.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(switch2.snp_bottom).offset(20)
        }
        switch3.tag = 3
        
        view.addSubview(label3)
        label3.snp_makeConstraints { (make) in
            make.centerY.equalTo(switch3)
            make.right.equalTo(switch3.snp_left).offset(-10)
            make.left.equalTo(view).offset(10)
        }
        label3.text = "On"
        label3.textAlignment = .Right
        
        view.layoutIfNeeded()
        
        switch1.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchWasTapped(_:)), forControlEvents: .ValueChanged)
        switch2.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchWasTapped(_:)), forControlEvents: .ValueChanged)
        switch3.addTarget(self, action: #selector(SwitchAndRadioExamplesVC.switchWasTapped(_:)), forControlEvents: .ValueChanged)
    }
    
    public func switchWasTapped(sender: WSwitch) {
        switch sender.tag {
        case 1:
            label1.text = sender.on ? "On" : "Off"
        case 2:
            label2.text = sender.on ? "On" : "Off"
        case 3:
            label3.text = sender.on ? "On" : "Off"
        default:
            break
        }
    }
}