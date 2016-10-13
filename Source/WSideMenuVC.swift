//
//  WSideMenuVC.swift
//  WMobileKit
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
    public var menuWidth: CGFloat = 300.0
    public var swipeToOpen = false
    public var swipeToOpenThreshold: CGFloat = 0.33
    public var autoOpenThreshold: CGFloat = 0.5
    public var useBlur = true
    public var showAboveStatusBar = true
    public var menuAnimationDuration = 0.3
    public var gesturesOpenSideMenu = true
    public var backgroundOpacity: CGFloat = 0.4
    public var statusBarStyle: UIStatusBarStyle = .LightContent
    public var drawerBorderColor: UIColor = .lightGrayColor()
    public var drawerIcon: UIImage?
    public var backIcon: UIImage?
}

enum WSideMenuState {
    case Open, Closed
}

public class WSideMenuVC: WSizeVC {
    // Setable properties
    weak public var mainViewController: UIViewController?
    public var leftSideMenuViewController: UIViewController?
    public var backgroundView: UIView!
    public var options: WSideMenuOptions?
    public weak var delegate: WSideMenuProtocol?

    // Internal properties
    var backgroundTapView = UIView()
    var mainContainerView = UIView()
    var leftSideMenuContainerView = UIView()
    var leftSideMenuBorderView = UIView()
    var menuState: WSideMenuState = .Closed
    var statusBarHidden = false

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

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().translucent = false

        setupMenu()
    }

    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let options = options {
            return options.statusBarStyle
        }

        return .Default
    }

    public func setupMenu() {
        if options == nil {
            // Use default options if not specified
            options = WSideMenuOptions()
        }

        // Initial setup of views
        view.addSubview(mainContainerView)

        // Add background tap view behind the side menu
        view.insertSubview(backgroundTapView, aboveSubview: mainContainerView)

        view.addSubview(leftSideMenuContainerView)

        mainContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        backgroundTapView.snp_makeConstraints { (make) in
            make.left.equalTo(leftSideMenuContainerView.snp_right)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        leftSideMenuContainerView.snp_makeConstraints { (make) in
            make.height.equalTo(view)
            make.width.equalTo(options!.menuWidth)
            make.right.equalTo(view.snp_left)
        }

        if let mainViewController = mainViewController {
            // Add a tap gesture recongizer to the backgroundTapView
            // When the side menu is open, allow it to be tapped to close it
            let backgroundTapRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(WSideMenuVC.backgroundWasTapped(_:)))
            backgroundTapView.hidden = true
            backgroundTapView.addGestureRecognizer(backgroundTapRecognizer)
            
            if (options!.swipeToOpen) {
                let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WSideMenuVC.didPan(_:)))
                view.addGestureRecognizer(panGestureRecognizer)
            }

            addViewControllerToContainer(mainContainerView, viewController: mainViewController)
            
            if let mainViewController = mainViewController as? WSideMenuContentVC {
                mainViewController.addWSideMenuButtons()
            } else if let mainViewController = mainViewController as? UINavigationController {
                if let rootVC = mainViewController.viewControllers[0] as? WSideMenuContentVC {
                    rootVC.addWSideMenuButtons()
                }
            }
        }

        if let leftSideMenuViewController = leftSideMenuViewController {
            if options!.useBlur {
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
                leftSideMenuContainerView.addSubview(blurView)
                blurView.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(leftSideMenuContainerView)
                    make.top.equalTo(leftSideMenuContainerView)
                    make.right.equalTo(leftSideMenuContainerView)
                    make.bottom.equalTo(leftSideMenuContainerView)
                })
                
                leftSideMenuBorderView.backgroundColor = options!.drawerBorderColor
                leftSideMenuContainerView.addSubview(leftSideMenuBorderView)
                
                leftSideMenuBorderView.snp_makeConstraints() { (make) in
                    make.right.equalTo(leftSideMenuContainerView)
                    make.bottom.equalTo(leftSideMenuContainerView)
                    make.top.equalTo(leftSideMenuContainerView)
                    make.width.equalTo(1)
                }
            }
            
            addViewControllerToContainer(leftSideMenuContainerView, viewController: leftSideMenuViewController)
        }
    }
    
    public func didPan(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(view)
        let isMovingRight = velocity.x > 0
        let location = recognizer.locationInView(view).x
        let translation = recognizer.translationInView(view).x
        let width = options!.menuWidth
        
        switch recognizer.state {
            case .Began:
                if (delegate?.sideMenuShouldOpenSideMenu?() == false) {
                    recognizer.enabled = false
                    return
                }
                
                if (menuState == .Closed) {
                    if (isMovingRight) {
                        // If the menu is closed only start to open if the touch began on the specified threshold
                        if (location > view.frame.width * options!.swipeToOpenThreshold) {
                            recognizer.enabled = false
                        } else {
                            if options!.showAboveStatusBar {
                                hideStatusBar(true)
                            }
                            backgroundTapView.hidden = false
                        }
                    }
                } else {
                    // A leftswipe anywhere outside the menu will start to close the menu
                    if (!isMovingRight && location < width) {
                        recognizer.enabled = false
                    }
                }
            case .Changed:
                leftSideMenuContainerView.snp_remakeConstraints { (make) in
                    if (menuState == .Closed) {
                        make.right.equalTo(view.snp_left).offset(min(translation, width))
                    } else {
                        make.left.equalTo(view).offset(min(translation, 0))
                    }
                    
                    make.height.equalTo(view)
                    make.width.equalTo(width)
                }
                
                view.layoutIfNeeded()
                
                // animate the shadow based on the percentage the drawer has animated in
                backgroundTapView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(percentageMoved() * options!.backgroundOpacity)
            case .Ended:
                let x = abs(leftSideMenuContainerView.frame.origin.x)
                
                // If the drawer has animated out past the threshold, open it
                if (x < width * options!.autoOpenThreshold) {
                    openSideMenu()
                } else {
                    closeSideMenu()
                }
            case .Cancelled:
                recognizer.enabled = true
            default:
                break
        }
    }
    
    public func changeMainViewController(newMainViewController: UIViewController) {
        // Swaps out main view controller
        removeViewControllerFromContainer(mainViewController)
        mainViewController = newMainViewController
        addViewControllerToContainer(mainContainerView, viewController: mainViewController)
        view.layoutIfNeeded()
    }
    
    public func toggleSideMenu() {
        switch menuState {
        case .Closed:
            openSideMenu()
        case .Open:
            closeSideMenu()
        }
    }
    
    public func hideStatusBar(hide: Bool) {
        statusBarHidden = hide
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            window?.windowLevel = hide ? UIWindowLevelStatusBar : UIWindowLevelNormal            
        }
    }
    
    public func percentageMoved() -> CGFloat {
        if let width = options?.menuWidth {
            return 1 - (abs(leftSideMenuContainerView.frame.origin.x) / width)
        }
        
        return 0
    }

    public func openSideMenu() {
        if (delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }

        // Enable the tap outside the drawer to close on when side menu is open
        backgroundTapView.hidden = false

        delegate?.sideMenuWillOpen?()
        
        if options!.showAboveStatusBar {
            hideStatusBar(true)
        }
        
        leftSideMenuContainerView.snp_remakeConstraints { (make) in
            make.height.equalTo(self.view)
            make.width.equalTo(self.options!.menuWidth)
            make.left.equalTo(self.view)
        }
        
        UIView.animateWithDuration(options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.backgroundTapView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(self.options!.backgroundOpacity)
            },
            completion: { finished in
                self.menuState = .Open
                self.delegate?.sideMenuDidOpen?()
            }
        )
    }

    public func closeSideMenu() {
        delegate?.sideMenuWillClose?()
        
        leftSideMenuContainerView.snp_remakeConstraints { (make) in
            make.height.equalTo(self.view)
            make.width.equalTo(self.options!.menuWidth)
            make.right.equalTo(self.view.snp_left)
        }

        UIView.animateWithDuration(options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.backgroundTapView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            },
            completion: { finished in
                if self.options!.showAboveStatusBar {
                    self.hideStatusBar(false)
                }
                
                self.menuState = .Closed
                self.delegate?.sideMenuDidClose?()
                
                // Disable the tap outside the drawer to close
                self.backgroundTapView.hidden = true
            }
        )
    }

    @objc
    func backgroundWasTapped(sender: AnyObject) {
        closeSideMenu()
    }
    
    deinit {
        removeViewControllerFromContainer(mainViewController)
        removeViewControllerFromContainer(leftSideMenuViewController)
    }
}

public class WSideMenuContentVC: WSizeVC, WSideMenuProtocol {
    public var paddingBetweenBackAndMenuIcons: CGFloat = 20.0 {
        didSet {
            addWSideMenuButtons()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().translucent = false
    }

    public func addWSideMenuButtons() {
        // Adds a button to open the side menu
        // If this VC is not the first rootVc for its nav controller, add a back button as well
        var sideMenuButtonItem: UIBarButtonItem = UIBarButtonItem()

        if let sideMenuController = sideMenuController() {
            if let menuIcon = sideMenuController.options?.drawerIcon?.imageWithRenderingMode(.AlwaysOriginal) {
                sideMenuButtonItem = UIBarButtonItem(image: menuIcon,
                    style: .Plain,
                    target: self,
                    action: #selector(WSideMenuContentVC.toggleSideMenu))
            } else {
                sideMenuButtonItem = UIBarButtonItem(title: "Toggle",
                    style: .Plain,
                    target: self,
                    action: #selector(WSideMenuContentVC.toggleSideMenu))
            }

            sideMenuButtonItem.accessibilityIdentifier = "SideMenuButton"

            if (navigationController?.viewControllers.count > 1 && navigationController?.topViewController == self) {
                var backMenuButtonItem = UIBarButtonItem()

                if let backIcon = sideMenuController.options?.backIcon {
                    backMenuButtonItem = UIBarButtonItem(image: backIcon,
                        style: .Plain,
                        target: self,
                        action: #selector(WSideMenuContentVC.backButtonItemWasTapped(_:)))
                } else {
                    backMenuButtonItem = UIBarButtonItem(title: "Back",
                        style: .Plain,
                        target: self,
                        action: #selector(WSideMenuContentVC.backButtonItemWasTapped(_:)))
                }

                sideMenuButtonItem.imageInsets = UIEdgeInsetsMake(0, -paddingBetweenBackAndMenuIcons, 0, paddingBetweenBackAndMenuIcons)

                navigationItem.leftBarButtonItems = [backMenuButtonItem, sideMenuButtonItem]
            } else {
                navigationItem.leftBarButtonItem = sideMenuButtonItem
            }
        }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
        
        addWSideMenuButtons()
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
