//
//  LeftMenuVCExample.swift
//  WMobileKitExample
//
//  Copyright 2017 Workiva Inc.
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

import UIKit
import WMobileKit

class NavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class LeftMenuTVCExample: UITableViewController {
    // Use the class name as the identifier
    lazy var welcomeVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeVC") as! NavigationVC
    lazy var pagingControlExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "PagingControlExamplesVC") as! NavigationVC
    lazy var pagingSelectorVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "WPagingSelectorVC") as! NavigationVC
    lazy var userLogoViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "UserLogoViewExamplesVC") as! NavigationVC
    lazy var modalViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "ModalViewExamplesVC") as! NavigationVC
    lazy var textFieldExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "TextFieldExamplesVC") as! NavigationVC
    lazy var textViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "TextViewExamplesVC") as! NavigationVC
    lazy var markdownTextViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MarkdownTextViewExamplesVC") as! NavigationVC
    lazy var spinnerExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "SpinnerExamplesVC") as! NavigationVC
    lazy var loadingModalExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "LoadingModalExamplesVC") as! NavigationVC
    lazy var autoCompleteTextViewExampleVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "AutoCompleteTextViewExampleVC") as! NavigationVC
    lazy var switchAndRadioExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "SwitchAndRadioExamplesVC") as! NavigationVC
    lazy var badgeExamplesVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "BadgeExamplesVC") as! NavigationVC
    lazy var panelExampleVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "PanelExampleVC") as! NavigationVC
    lazy var autoViewLayoutExampleVC: NavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "AutoViewLayoutExampleVC") as! NavigationVC

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            sideMenuController()?.changeMainViewController(welcomeVC)
        case 1:
            sideMenuController()?.changeMainViewController(pagingControlExamplesVC)
        case 2:
            sideMenuController()?.changeMainViewController(pagingSelectorVC)
        case 3:
            sideMenuController()?.changeMainViewController(userLogoViewExamplesVC)
        case 4:
            sideMenuController()?.changeMainViewController(modalViewExamplesVC)
        case 5:
            sideMenuController()?.changeMainViewController(textFieldExamplesVC)
        case 6:
            sideMenuController()?.changeMainViewController(textViewExamplesVC)
        case 7:
            sideMenuController()?.changeMainViewController(markdownTextViewExamplesVC)
        case 8:
            sideMenuController()?.changeMainViewController(spinnerExamplesVC)
        case 9:
            sideMenuController()?.changeMainViewController(loadingModalExamplesVC)
        case 10:
            sideMenuController()?.changeMainViewController(autoCompleteTextViewExampleVC)
        case 11:
            sideMenuController()?.changeMainViewController(switchAndRadioExamplesVC)
        case 12:
            sideMenuController()?.changeMainViewController(badgeExamplesVC)
        case 13:
            sideMenuController()?.changeMainViewController(panelExampleVC)
        case 14:
            sideMenuController()?.changeMainViewController(autoViewLayoutExampleVC)
        default:
            break
        }

        sideMenuController()?.closeSideMenu()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    func defaultVC() -> UIViewController {
        return welcomeVC
    }
}
