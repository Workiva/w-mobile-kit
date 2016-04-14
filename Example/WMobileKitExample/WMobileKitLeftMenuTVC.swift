//
//  WMobileKitLeftMenuTVC.swift
//  WMobileKitExample

import UIKit
import WMobileKit

class WMobileKitLeftMenuTVC: UITableViewController {

    lazy var baseContentVC:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc0") as! WMobileKitNVC // WSideMenuContentVC
    lazy var pagingControlExamples:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc1") as! WMobileKitNVC // WMobileKitPagingControlExamplesVC
    lazy var pagingSelectorVC:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc3") as! WMobileKitNVC // WPagingSelectorVC
    lazy var userLogoExamples:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc5") as! WMobileKitNVC // WMobileKitUserLogoExamplesVC

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            sideMenuController()?.changeMainViewController(baseContentVC)
            break
        case 1:
            sideMenuController()?.changeMainViewController(pagingControlExamples)
            break
        case 2:
            // Create simple VC's to send to pagingSelectorVC
            let vc1 = WSideMenuContentVC()
            let vc2 = WSideMenuContentVC()
            let vc3 = WSideMenuContentVC()
            let vc4 = mainStoryboard.instantiateViewControllerWithIdentifier("vc4") as! WSideMenuContentVC
            vc1.view.backgroundColor = UIColor.greenColor()
            vc2.view.backgroundColor = UIColor.blueColor()
            vc3.view.backgroundColor = UIColor.redColor()

            if let pagingVC = pagingSelectorVC.viewControllers[0] as? WPagingSelectorVC {
                pagingVC.tabWidth = 90
                pagingVC.tabTextColor = WThemeManager.sharedInstance.currentTheme.secondaryTextColor
                // FIXME: This value can be changed, should be removed or altered before public release
                // pagingVC.pagingControlHeight = 100

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
        case 3:
            sideMenuController()?.changeMainViewController(userLogoExamples)
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
        return baseContentVC
    }
}
