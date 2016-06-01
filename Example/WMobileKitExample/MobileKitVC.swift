//
//  MobileKitVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class MobileKitVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}
