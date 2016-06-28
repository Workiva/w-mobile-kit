//
//  PagingControlVCExampleVC.swift
//  WMobileKitExample
//
//  Copyright 2016 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import WMobileKit

public class PagingControlVCExampleVC: WPagingSelectorVC {
    var scrollView: UIScrollView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create simple VC's to send to pagingSelectorVC
        let vc1 = mainStoryboard.instantiateViewControllerWithIdentifier("textVC") as! PagingSelectorDelegateVC
        
        let vc2 = WSideMenuContentVC()
        vc2.view.backgroundColor = UIColor(hex: 0x0000B2) // dark blue
        
        let vc3 = WSideMenuContentVC()
        vc3.view.backgroundColor = UIColor(hex: 0x990000) // dark red
        
        let vc4 = WSideMenuContentVC()
        vc4.view.backgroundColor = UIColor(hex: 0x006600) // dark green
        
        tabWidth = 90
        pagingControlHeight = 44
        tabTextColor = WThemeManager.sharedInstance.currentTheme.secondaryTextColor
            
        let subviews = vc1.view.subviews
        if let scrollView = subviews[0] as? UIScrollView {
            self.scrollView = scrollView
            scrollView.delegate = self
        }
        
        delegate = vc1
        
        let pages = [
            WPage(title: "Text VC", viewController: vc1),
            WPage(title: "Blue VC", viewController: vc2),
            WPage(title: "Red VC", viewController: vc3),
            WPage(title: "Green VC", viewController: vc4)
        ]
        
        self.pages = pages
        
        separatorLineHeight = 3.0
        shadowColor = UIColor.purpleColor().CGColor
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }
}

public class PagingSelectorDelegateVC: WSideMenuContentVC, WPagingSelectorVCDelegate {
    public func shouldShowShadow(sender: WPagingSelectorVC) -> Bool {
        if let scrollView = view.subviews[0] as? UIScrollView {
            return scrollView.contentOffset.y > 0
        }
        
        return false
    }
}