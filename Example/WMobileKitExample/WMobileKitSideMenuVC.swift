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

        let tabLayout = WPagingSelectorVC(titles: ["Recent", "All Files"])
        
        view.addSubview(tabLayout);
        tabLayout.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(navigationBar.snp_bottom)
        }
        
        tabLayout.layoutSubviews()
        
        let tabLayout2 = WPagingSelectorVC(titles: ["Recent", "All Files", "Snapshots"])
        
        view.addSubview(tabLayout2);
        tabLayout2.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout.snp_bottom)
        }
    
        tabLayout2.layoutSubviews()
        
        let tabLayout3 = WPagingSelectorVC(titles: ["Recent", "All Files", "Snapshots", "More tabs!"])
        
        view.addSubview(tabLayout3);
        tabLayout3.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(tabLayout2.snp_bottom)
        }
        
        tabLayout3.layoutSubviews()
    }
}
