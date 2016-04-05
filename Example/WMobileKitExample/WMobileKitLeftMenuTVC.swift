//
//  WMobileKitLeftMenuTVC.swift
//  WMobileKitExample

import UIKit
import WMobileKit

class WMobileKitLeftMenuTVC: UITableViewController {

    lazy var baseContentVC:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc0") as! WMobileKitNVC // WSideMenuContentVC
    lazy var pagingControlExamples:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc1") as! WMobileKitNVC // WMobileKitPagingControlExamplesVC
    lazy var pagingSelectorVC:WMobileKitNVC = mainStoryboard.instantiateViewControllerWithIdentifier("vc3") as! WMobileKitNVC // WPagingSelectorVC

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            sideMenuController()?.changeMainViewController(baseContentVC)
            break
        case 1:
            sideMenuController()?.changeMainViewController(pagingControlExamples)
            break
        case 2:
//            var page = WPage(title: title, viewController: nil)
            if let pagingVC = pagingSelectorVC.viewControllers[0] as? WPagingSelectorVC {
                let pages = [
                    // TODO: Add controllers to this
                    WPage(title: "test1"),
                    WPage(title: "test2")
                ]

                pagingVC.pages = pages
            }


//            pagingSelectorVC.rootviewC
//            pagingSelectorVC.pages = pages

            sideMenuController()?.changeMainViewController(pagingSelectorVC)
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
