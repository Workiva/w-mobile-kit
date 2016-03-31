//
//  WMobileKitLeftMenuTVC.swift
//  WMobileKitExample

import UIKit

class WMobileKitLeftMenuTVC: UITableViewController {

    lazy var vc0 = mainStoryboard.instantiateViewControllerWithIdentifier("vc0")

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            sideMenuController()?.changeMainViewController(vc0)
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
        return vc0
    }
}
