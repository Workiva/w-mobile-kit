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
    lazy var pagingControlExamplesVC:NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("PagingControlExamplesVC") as! NavigationVC
    lazy var pagingSelectorVC:NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("WPagingSelectorVC") as! NavigationVC
    lazy var userLogoViewExamplesVC:NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("UserLogoViewExamplesVC") as! NavigationVC
    lazy var modalViewExamplesVC:NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("ModalViewExamplesVC") as! NavigationVC
    lazy var textFieldExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("TextFieldExamplesVC") as! NavigationVC
    lazy var textViewExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("TextViewExamplesVC") as! NavigationVC
    lazy var spinnerExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SpinnerExamplesVC") as! NavigationVC
    lazy var loadingModalExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoadingModalExamplesVC") as! NavigationVC
    lazy var autoCompleteTextFieldExampleVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("AutoCompleteTextFieldExampleVC") as! NavigationVC
    lazy var switchAndRadioExamplesVC: NavigationVC = mainStoryboard.instantiateViewControllerWithIdentifier("SwitchAndRadioExamplesVC") as! NavigationVC

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            sideMenuController()?.changeMainViewController(pagingControlExamplesVC)
            break
        case 1:
            // Create simple VC's to send to pagingSelectorVC
            let vc1 = WSideMenuContentVC()
            vc1.view.backgroundColor = UIColor.greenColor()

            let vc2 = WSideMenuContentVC()
            vc2.view.backgroundColor = UIColor.blueColor()

            let vc3 = WSideMenuContentVC()
            vc3.view.backgroundColor = UIColor.redColor()

            let vc4 = mainStoryboard.instantiateViewControllerWithIdentifier("textVC") as! WSideMenuContentVC

            if let pagingVC = pagingSelectorVC.viewControllers[0] as? WPagingSelectorVC {
                pagingVC.tabWidth = 90
                pagingVC.pagingControlHeight = 44
                pagingVC.tabTextColor = WThemeManager.sharedInstance.currentTheme.secondaryTextColor

                let pages = [
                    WPage(title: "Green VC", viewController: vc1),
                    WPage(title: "Blue VC", viewController: vc2),
                    WPage(title: "Red VC", viewController: vc3),
                    WPage(title: "Text VC", viewController: vc4)
                ]

                pagingVC.pages = pages
            }

            sideMenuController()?.changeMainViewController(pagingSelectorVC)
            break
        case 2:
            sideMenuController()?.changeMainViewController(userLogoViewExamplesVC)
            break
        case 3:
            sideMenuController()?.changeMainViewController(modalViewExamplesVC)
            break
        case 4:
            sideMenuController()?.changeMainViewController(textFieldExamplesVC)
            break
        case 5:
            sideMenuController()?.changeMainViewController(textViewExamplesVC)
            break
        case 6:
            sideMenuController()?.changeMainViewController(spinnerExamplesVC)
            break
        case 7:
            sideMenuController()?.changeMainViewController(loadingModalExamplesVC)
            break
        case 8:
            sideMenuController()?.changeMainViewController(autoCompleteTextFieldExampleVC)
            break
        case 9:
            sideMenuController()?.changeMainViewController(switchAndRadioExamplesVC)
            break
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
        return pagingControlExamplesVC
    }
}
