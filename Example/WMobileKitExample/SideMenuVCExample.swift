//
//  SideMenuVCExample.swift
//  WMobileKitExample

import UIKit
import WMobileKit

class SideMenuVCExample: WSideMenuVC {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        var menuOptions = WSideMenuOptions()
        menuOptions.menuWidth = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 320 : 300
        menuOptions.drawerIcon = UIImage(named: "drawer")
        options = menuOptions

        let leftMenu = mainStoryboard.instantiateViewControllerWithIdentifier("LeftMenu") as! LeftMenuTVCExample
        leftSideMenuViewController = leftMenu
        mainViewController = leftMenu.defaultVC()
    }
}
