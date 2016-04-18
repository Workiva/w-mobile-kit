//
//  SideMenuVCExample.swift
//  WMobileKitExample

import UIKit
import WMobileKit

class SideMenuVCExample: WSideMenuVC {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let leftMenu = mainStoryboard.instantiateViewControllerWithIdentifier("LeftMenu") as! LeftMenuTVCExample
        leftSideMenuViewController = leftMenu
        mainViewController = leftMenu.defaultVC()
    }
}
