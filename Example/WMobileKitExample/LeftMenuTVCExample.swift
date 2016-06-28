//
//  LeftMenuVCExample.swift
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

import UIKit
import WMobileKit

class NavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class LeftMenuTVCExample: UITableViewController {
    // Use the class name as the identifier
    lazy var welcomeVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("WelcomeVC") as! NavigationVC
    lazy var pagingControlExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("PagingControlExamplesVC") as! NavigationVC
    lazy var pagingSelectorVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("WPagingSelectorVC") as! NavigationVC
    lazy var userLogoViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("UserLogoViewExamplesVC") as! NavigationVC
    lazy var modalViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("ModalViewExamplesVC") as! NavigationVC
    lazy var textFieldExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("TextFieldExamplesVC") as! NavigationVC
    lazy var textViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("TextViewExamplesVC") as! NavigationVC
    lazy var markdownTextViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("MarkdownTextViewExamplesVC") as! NavigationVC
    lazy var spinnerExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SpinnerExamplesVC") as! NavigationVC
    lazy var loadingModalExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoadingModalExamplesVC") as! NavigationVC
    lazy var autoCompleteTextViewExampleVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("AutoCompleteTextViewExampleVC") as! NavigationVC
    lazy var switchAndRadioExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SwitchAndRadioExamplesVC") as! NavigationVC
    lazy var badgeExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("BadgeExamplesVC") as! NavigationVC

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
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
        default:
            break
        }

        sideMenuController()?.closeSideMenu()

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    func defaultVC() -> UIViewController {
        return welcomeVC
    }
}
