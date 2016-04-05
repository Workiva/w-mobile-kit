//
//  WSideMenuVC.swift
//  WMobileKit

import UIKit
import SnapKit

@objc public protocol WSideMenuProtocol: NSObjectProtocol {
    optional func sideMenuWillOpen()
    optional func sideMenuWillClose()
    optional func sideMenuDidOpen()
    optional func sideMenuDidClose()
    optional func sideMenuShouldOpenSideMenu () -> Bool
}

public struct WSideMenuOptions {
    public init(){}

    // Default WSideMenu options, change before calling super.viewDidLoad()
    public var menuWidth = 300.0
    public var useBlur = true
    // NOTE: Only works with solid color status bars with translucent = false
    public var showAboveStatusBar = true
    public var menuAnimationDuration = 0.3
    public var gesturesOpenSideMenu = true
    public var statusBarStyle: UIStatusBarStyle = .LightContent
}

private enum WSideMenuState {
    case Open
    case Closed
}

public class WSideMenuVC: UIViewController {
    // Setable properties
    public var mainViewController: UIViewController?
    public var leftSideMenuViewController: UIViewController?
    public var options: WSideMenuOptions?
    public weak var delegate: WSideMenuProtocol?

    // Internal properties
    private var mainContainerView = UIView(frame: CGRect.zero)
    private var leftSideMenuContainerView = UIView(frame: CGRect.zero)
    private var mainContainerTapRecognizer: UITapGestureRecognizer?
    private var menuState: WSideMenuState = .Closed
    private var statusBarView = UIView()
    private var statusBarHidden = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(mainViewController: UIViewController, leftSideMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftSideMenuViewController = leftSideMenuViewController
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
    }

    public func setupMenu() {
        if options == nil {
            // Use default options if not specified
            options = WSideMenuOptions()
        }

        // Initial setup of views
        view.addSubview(mainContainerView)
        view.insertSubview(leftSideMenuContainerView, aboveSubview: mainContainerView)

        if options!.showAboveStatusBar {
            view.insertSubview(statusBarView, belowSubview: leftSideMenuContainerView)

            statusBarView.snp_makeConstraints { (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(20)
                make.top.equalTo(view)
            }
        }

        mainContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            if options!.showAboveStatusBar {
                make.top.equalTo(statusBarView.snp_bottom)
            } else {
                make.top.equalTo(view)
            }

            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        leftSideMenuContainerView.snp_makeConstraints { (make) in
            make.height.equalTo(view)
            make.width.equalTo(options!.menuWidth)
            make.right.equalTo(view.snp_left)
        }

        if let mainViewController = mainViewController {
            // Add a tap gesture recongizer to the mainContainerView
            // When the side menu is open, allow it to be tapped to close it
            mainContainerTapRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(WSideMenuVC.mainContainerViewWasTapped(_:)))
            mainContainerTapRecognizer?.enabled = false
            mainContainerView.addGestureRecognizer(mainContainerTapRecognizer!)
            addViewControllerToContainer(mainContainerView, viewController: mainViewController)

            if options!.showAboveStatusBar {
                if let mainViewController = mainViewController as? UINavigationController {
                    statusBarView.backgroundColor = mainViewController.navigationBar.barTintColor
                } else {
                    statusBarView.backgroundColor = mainViewController.view.backgroundColor
                }
            }
        }

        if let leftSideMenuViewController = leftSideMenuViewController {
            if options!.useBlur {
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
                leftSideMenuContainerView.addSubview(blurView)
                blurView.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(leftSideMenuContainerView)
                    make.top.equalTo(leftSideMenuContainerView)
                    make.right.equalTo(leftSideMenuContainerView)
                    make.bottom.equalTo(leftSideMenuContainerView)
                })

                // Add leftSideMenuVc as a sub view of the blurView.contentView
                // The blur only blurs views under it and nothing in the contentView
                addViewControllerToContainer(blurView.contentView, viewController: leftSideMenuViewController)
            } else {
                addViewControllerToContainer(leftSideMenuContainerView, viewController: leftSideMenuViewController)
            }
        }
    }
    
    public func changeMainViewController(newMainViewController: UIViewController) {
        // Swaps out main view controller
        removeViewControllerFromContainer(mainViewController)
        mainViewController = newMainViewController
        addViewControllerToContainer(mainContainerView, viewController: mainViewController)
        view.layoutIfNeeded()
    }

    public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        if let options = options {
            return options.showAboveStatusBar ? .Slide : .None
        } else {
            return .None
        }
    }

    public override func prefersStatusBarHidden() -> Bool {
        if let options = options {
            if options.showAboveStatusBar {
                return statusBarHidden
            } else {
                return false
            }
        } else {
            return false
        }
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let options = options {
            return options.statusBarStyle
        } else {
            return .Default
        }
    }

    public func toggleSideMenu() {
        switch menuState {
        case .Closed:
            openSideMenu()
            break
        case .Open:
            closeSideMenu()
            break
        }
    }

    public func openSideMenu() {
        if (delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }

        // Enable the tap outside the drawer to close on when side menu is open
        mainContainerTapRecognizer?.enabled = true

        leftSideMenuContainerView.snp_remakeConstraints { (make) in
            make.height.equalTo(view)
            make.width.equalTo(options!.menuWidth)
            make.left.equalTo(view)
        }

        delegate?.sideMenuWillOpen?()

        statusBarHidden = !statusBarHidden

        UIView.animateWithDuration(options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            },
            completion: { finished in
                self.menuState = .Open
                self.delegate?.sideMenuDidOpen?()
            }
        )
    }

    public func closeSideMenu() {
        // Disable the tap outside the drawer to close
        mainContainerTapRecognizer?.enabled = false

        leftSideMenuContainerView.snp_remakeConstraints { (make) in
            make.height.equalTo(view)
            make.width.equalTo(options!.menuWidth)
            make.right.equalTo(view.snp_left)
        }

        delegate?.sideMenuWillClose?()

        statusBarHidden = !statusBarHidden

        UIView.animateWithDuration(options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            },
            completion: { finished in
                self.menuState = .Closed
                self.delegate?.sideMenuDidClose?()
            }
        )
    }

    func mainContainerViewWasTapped(sender: AnyObject) {
        closeSideMenu()
    }
}

public class WSideMenuContentVC: UIViewController, WSideMenuProtocol {
    public override func viewDidLoad() {
        super.viewDidLoad()
        addWSideMenuButtons()
    }

    public func addWSideMenuButtons() {
        // Adds a button to open the side menu
        // If this VC is not the first rootVc for its nav controller, add a back button as well
        let sideMenuButtonItem = UIBarButtonItem(title: "Toggle",
                                                 style: .Plain,
                                                 target: self,
                                                 action: #selector(WSideMenuContentVC.toggleSideMenu))

        if (navigationController?.viewControllers.count > 1) {
            let backMenuButtonItem = UIBarButtonItem(title: "Back",
                                                     style: .Plain,
                                                     target: self,
                action:#selector(WSideMenuContentVC.backButtonItemWasTapped(_:)))
            
            navigationItem.leftBarButtonItems = [backMenuButtonItem, sideMenuButtonItem]
        } else {
            navigationItem.leftBarButtonItem = sideMenuButtonItem
        }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
    }

    public func toggleSideMenu() {
        sideMenuController()?.toggleSideMenu()
    }

    public func backButtonItemWasTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension UIViewController {
    // UIViewController extension that will return the current WSideMenuViewController
    // Only works if the VC is a child vc of the WSideMenuViewController instance
    public func sideMenuController() -> WSideMenuVC? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is WSideMenuVC {
                return viewController as? WSideMenuVC
            }
            viewController = viewController?.parentViewController
        }
        return nil;
    }
    
    public func addViewControllerToContainer(containerView: UIView, viewController: UIViewController?) {
        // Adds a view controller as a child view controller and calls needed life cycle methods
        if let targetViewController = viewController {
            addChildViewController(targetViewController)
            containerView.addSubview(targetViewController.view)
            
            targetViewController.view.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(containerView)
                make.top.equalTo(containerView)
                make.right.equalTo(containerView)
                make.bottom.equalTo(containerView)
            })
            
            targetViewController.didMoveToParentViewController(self)
        }
    }
    
    public func removeViewControllerFromContainer(viewController: UIViewController?) {
        // Removes a child view controller and calls needed life cyle methods
        if let targetViewController = viewController {
            targetViewController.willMoveToParentViewController(nil)
            targetViewController.view.removeFromSuperview()
            targetViewController.removeFromParentViewController()
        }
    }
}
