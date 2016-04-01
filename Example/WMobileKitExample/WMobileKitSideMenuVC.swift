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

        navigationBar.barTintColor = UIColor.blackColor()

        let tabLayout = WTabLayout(titles: ["Recents", "All Files"])
        
        view.addSubview(tabLayout);
        tabLayout.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(navigationBar.snp_bottom)
        }
        
        tabLayout.layoutSubviews()
    }
}
