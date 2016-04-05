//
//  WMobileKitSideMenuVC.swift
//  WMobileKit

import UIKit
import WMobileKit
import SnapKit

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

        // NOTE: Not sure why this doesn't work with the theme in the app delegate
        let theme: WTheme = GreenTheme()
        navigationBar.barTintColor = theme.navigationColor
    }
}
