//
//  AutoFillTextFieldExampleVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class AutoFillTextFieldExampleVC: WSideMenuContentVC {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField = WAutoFillTextView()
        view.addSubview(textField)
        
    }
}