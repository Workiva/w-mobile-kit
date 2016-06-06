//
//  LeftMenuVCExample.swift
//  WMobileKitExample

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
    lazy var spinnerExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SpinnerExamplesVC") as! NavigationVC
    lazy var loadingModalExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoadingModalExamplesVC") as! NavigationVC
    lazy var autoCompleteTextFieldExampleVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("AutoCompleteTextFieldExampleVC") as! NavigationVC
    lazy var switchAndRadioExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SwitchAndRadioExamplesVC") as! NavigationVC
    lazy var badgeExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("BadgeExamplesVC") as! NavigationVC

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            sideMenuController()?.changeMainViewController(welcomeVC)
        case 1:
            sideMenuController()?.changeMainViewController(pagingControlExamplesVC)
        case 2:
            // Create simple VC's to send to pagingSelectorVC
            let vc1 = mainStoryboard.instantiateViewControllerWithIdentifier("textVC") as! WSideMenuContentVC

            let vc2 = WSideMenuContentVC()
            vc2.view.backgroundColor = UIColor(hex: 0x0000B2) // dark blue

            let vc3 = WSideMenuContentVC()
            vc3.view.backgroundColor = UIColor(hex: 0x990000) // dark red

            let vc4 = WSideMenuContentVC()
            vc4.view.backgroundColor = UIColor(hex: 0x006600) // dark green

            if let pagingVC = pagingSelectorVC.viewControllers[0] as? WPagingSelectorVC {
                pagingVC.tabWidth = 90
                pagingVC.pagingControlHeight = 44
                pagingVC.tabTextColor = WThemeManager.sharedInstance.currentTheme.secondaryTextColor

                let pages = [
                    WPage(title: "Text VC", viewController: vc1),
                    WPage(title: "Blue VC", viewController: vc2),
                    WPage(title: "Red VC", viewController: vc3),
                    WPage(title: "Green VC", viewController: vc4)
                ]

                pagingVC.pages = pages
            }

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
            sideMenuController()?.changeMainViewController(spinnerExamplesVC)
        case 8:
            sideMenuController()?.changeMainViewController(loadingModalExamplesVC)
        case 9:
            sideMenuController()?.changeMainViewController(autoCompleteTextFieldExampleVC)
        case 10:
            sideMenuController()?.changeMainViewController(switchAndRadioExamplesVC)
        case 11:
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
