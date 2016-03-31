//
//  WMobileKitSideMenuVC.swift
//  WMobileKit

import UIKit
import WMobileKit

class WMobileKitSideMenuVC: WSideMenuVC {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let leftMenu = mainStoryboard.instantiateViewControllerWithIdentifier("LeftMenu") as! WMobileKitLeftMenuTVC
        leftSideMenuViewController = leftMenu
        mainViewController = leftMenu.defaultVC()
    }
}

class WMobileKitNVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.blackColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.translucent = false
    }
}
