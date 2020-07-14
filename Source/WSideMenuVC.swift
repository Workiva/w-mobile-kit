//
//  WSideMenuVC.swift
//  WMobileKit
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
import SnapKit

@objc public protocol WSideMenuProtocol: NSObjectProtocol {
    @objc optional func sideMenuWillOpen()
    @objc optional func sideMenuWillClose()
    @objc optional func sideMenuDidOpen()
    @objc optional func sideMenuDidClose()
    @objc optional func sideMenuShouldOpenSideMenu () -> Bool
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
    public var statusBarStyle: UIStatusBarStyle = .lightContent
    public var drawerBorderColor: UIColor = .lightGray
    public var drawerIcon: UIImage?
    public var backIcon: UIImage?
}

enum WSideMenuState {
    case open, closed
}

open class WSideMenuVC: WSizeVC {
    // Setable properties
    weak open var mainViewController: UIViewController?
    open var leftSideMenuViewController: UIViewController?
    open var backgroundView: UIView!
    open var options: WSideMenuOptions?
    open weak var delegate: WSideMenuProtocol?

    // Internal properties
    var backgroundTapView = UIView()
    var mainContainerView = UIView()
    var leftSideMenuContainerView = UIView()
    var leftSideMenuBorderView = UIView()
    var menuState: WSideMenuState = .closed
    var statusBarHidden = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(mainViewController: UIViewController, leftSideMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftSideMenuViewController = leftSideMenuViewController
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().isTranslucent = false

        setupMenu()
    }

    override open var preferredStatusBarStyle : UIStatusBarStyle {
        if let options = options {
            return options.statusBarStyle
        }

        return .default
    }

    open func setupMenu() {
        if options == nil {
            // Use default options if not specified
            options = WSideMenuOptions()
        }

        // Initial setup of views
        view.addSubview(mainContainerView)

        // Add background tap view behind the side menu
        view.insertSubview(backgroundTapView, aboveSubview: mainContainerView)

        view.addSubview(leftSideMenuContainerView)

        mainContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        backgroundTapView.snp.makeConstraints { (make) in
            make.left.equalTo(leftSideMenuContainerView.snp.right)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        leftSideMenuContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(view)
            make.width.equalTo(options!.menuWidth)
            make.right.equalTo(view.snp.left)
        }

        if let mainViewController = mainViewController {
            // Add a tap gesture recongizer to the backgroundTapView
            // When the side menu is open, allow it to be tapped to close it
            let backgroundTapRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(WSideMenuVC.backgroundWasTapped(_:)))
            backgroundTapView.isHidden = true
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
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)) as UIVisualEffectView
                leftSideMenuContainerView.addSubview(blurView)
                blurView.snp.makeConstraints { (make) in
                    make.left.equalTo(leftSideMenuContainerView)
                    make.top.equalTo(leftSideMenuContainerView)
                    make.right.equalTo(leftSideMenuContainerView)
                    make.bottom.equalTo(leftSideMenuContainerView)
                }
                
                leftSideMenuBorderView.backgroundColor = options!.drawerBorderColor
                leftSideMenuContainerView.addSubview(leftSideMenuBorderView)
                
                leftSideMenuBorderView.snp.makeConstraints() { (make) in
                    make.right.equalTo(leftSideMenuContainerView)
                    make.bottom.equalTo(leftSideMenuContainerView)
                    make.top.equalTo(leftSideMenuContainerView)
                    make.width.equalTo(1)
                }
            }
            
            addViewControllerToContainer(leftSideMenuContainerView, viewController: leftSideMenuViewController)
        }
    }
    
    @objc open func didPan(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: view)
        let isMovingRight = velocity.x > 0
        let location = recognizer.location(in: view).x
        let translation = recognizer.translation(in: view).x
        let width = options!.menuWidth
        
        switch recognizer.state {
            case .began:
                if (delegate?.sideMenuShouldOpenSideMenu?() == false) {
                    recognizer.isEnabled = false
                    return
                }
                
                if (menuState == .closed) {
                    if (isMovingRight) {
                        // If the menu is closed only start to open if the touch began on the specified threshold
                        if (location > view.frame.width * options!.swipeToOpenThreshold) {
                            recognizer.isEnabled = false
                        } else {
                            if options!.showAboveStatusBar {
                                hideStatusBar(true)
                            }
                            backgroundTapView.isHidden = false
                        }
                    }
                } else {
                    // A leftswipe anywhere outside the menu will start to close the menu
                    if (!isMovingRight && location < width) {
                        recognizer.isEnabled = false
                    }
                }
            case .changed:
                leftSideMenuContainerView.snp.remakeConstraints { (make) in
                    if (menuState == .closed) {
                        make.right.equalTo(view.snp.left).offset(min(translation, width))
                    } else {
                        make.left.equalTo(view).offset(min(translation, 0))
                    }
                    
                    make.height.equalTo(view)
                    make.width.equalTo(width)
                }
                
                view.layoutIfNeeded()
                
                // animate the shadow based on the percentage the drawer has animated in
                backgroundTapView.backgroundColor = UIColor.black.withAlphaComponent(percentageMoved() * options!.backgroundOpacity)
            case .ended:
                let x = abs(leftSideMenuContainerView.frame.origin.x)
                
                // If the drawer has animated out past the threshold, open it
                if (x < width * options!.autoOpenThreshold) {
                    openSideMenu()
                } else {
                    closeSideMenu()
                }
            case .cancelled:
                recognizer.isEnabled = true
            default:
                break
        }
    }
    
    open func changeMainViewController(_ newMainViewController: UIViewController) {
        // Swaps out main view controller
        removeViewControllerFromContainer(mainViewController)
        mainViewController = newMainViewController
        addViewControllerToContainer(mainContainerView, viewController: mainViewController)
        view.layoutIfNeeded()
    }
    
    open func toggleSideMenu() {
        switch menuState {
        case .closed:
            openSideMenu()
        case .open:
            closeSideMenu()
        }
    }
    
    open func hideStatusBar(_ hide: Bool) {
        statusBarHidden = hide
        
        if let window = UIApplication.shared.delegate?.window {
            window?.windowLevel = hide ? UIWindow.Level.statusBar : UIWindow.Level.normal            
        }
    }
    
    open func percentageMoved() -> CGFloat {
        if let width = options?.menuWidth {
            return 1 - (abs(leftSideMenuContainerView.frame.origin.x) / width)
        }
        
        return 0
    }

    open func openSideMenu() {
        if (delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }

        // Enable the tap outside the drawer to close on when side menu is open
        backgroundTapView.isHidden = false

        delegate?.sideMenuWillOpen?()
        
        if options!.showAboveStatusBar {
            hideStatusBar(true)
        }
        
        leftSideMenuContainerView.snp.remakeConstraints { (make) in
            make.height.equalTo(self.view)
            make.width.equalTo(self.options!.menuWidth)
            make.left.equalTo(self.view)
        }
        
        UIView.animate(withDuration: options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.backgroundTapView.backgroundColor = UIColor.black.withAlphaComponent(self.options!.backgroundOpacity)
            },
            completion: { finished in
                self.menuState = .open
                self.delegate?.sideMenuDidOpen?()
            }
        )
    }

    // Forwarding method call instead of having default parameter value to avoid breaking change
    open func closeSideMenu() {
        closeSideMenu(completion: nil)
    }

    // Allow completion block parameter to avoid having to replace the delegate
    open func closeSideMenu(completion: (() -> ())?) {
        delegate?.sideMenuWillClose?()
        
        leftSideMenuContainerView.snp.remakeConstraints { (make) in
            make.height.equalTo(self.view)
            make.width.equalTo(self.options!.menuWidth)
            make.right.equalTo(self.view.snp.left)
        }

        UIView.animate(withDuration: options!.menuAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
                self.backgroundTapView.backgroundColor = UIColor.black.withAlphaComponent(0)
            },
            completion: { finished in
                if self.options!.showAboveStatusBar {
                    self.hideStatusBar(false)
                }
                
                self.menuState = .closed
                self.delegate?.sideMenuDidClose?()
                
                // Disable the tap outside the drawer to close
                self.backgroundTapView.isHidden = true

                completion?()
            }
        )
    }

    @objc
    func backgroundWasTapped(_ sender: AnyObject) {
        closeSideMenu()
    }
    
    deinit {
        removeViewControllerFromContainer(mainViewController)
        removeViewControllerFromContainer(leftSideMenuViewController)
    }
}

open class WSideMenuContentVC: WSizeVC, WSideMenuProtocol {
    open var paddingBetweenBackAndMenuIcons: CGFloat = 20.0 {
        didSet {
            addWSideMenuButtons()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().isTranslucent = false
    }

    open func addWSideMenuButtons() {
        // Adds a button to open the side menu
        // If this VC is not the first rootVc for its nav controller, add a back button as well
        var sideMenuButtonItem: UIBarButtonItem = UIBarButtonItem()

        if let sideMenuController = sideMenuController() {
            if let menuIcon = sideMenuController.options?.drawerIcon?.withRenderingMode(.alwaysOriginal) {
                sideMenuButtonItem = UIBarButtonItem(image: menuIcon,
                    style: .plain,
                    target: self,
                    action: #selector(WSideMenuContentVC.toggleSideMenu))
            } else {
                sideMenuButtonItem = UIBarButtonItem(title: "Toggle",
                    style: .plain,
                    target: self,
                    action: #selector(WSideMenuContentVC.toggleSideMenu))
            }

            sideMenuButtonItem.accessibilityIdentifier = "SideMenuButton"

            if (navigationController?.viewControllers.count > 1 && navigationController?.topViewController == self) {
                var backMenuButtonItem = UIBarButtonItem()

                if let backIcon = sideMenuController.options?.backIcon {
                    backMenuButtonItem = UIBarButtonItem(image: backIcon,
                        style: .plain,
                        target: self,
                        action: #selector(WSideMenuContentVC.backButtonItemWasTapped(_:)))
                } else {
                    backMenuButtonItem = UIBarButtonItem(title: "Back",
                        style: .plain,
                        target: self,
                        action: #selector(WSideMenuContentVC.backButtonItemWasTapped(_:)))
                }

                sideMenuButtonItem.imageInsets = UIEdgeInsets.init(top: 0, left: -paddingBetweenBackAndMenuIcons, bottom: 0, right: paddingBetweenBackAndMenuIcons)

                navigationItem.leftBarButtonItems = [backMenuButtonItem, sideMenuButtonItem]
            } else {
                navigationItem.leftBarButtonItem = sideMenuButtonItem
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the WSideMenu delegate when the VC appears
        sideMenuController()?.delegate = self
        
        addWSideMenuButtons()
    }

    @objc open func toggleSideMenu() {
        sideMenuController()?.toggleSideMenu()
    }

    @objc open func backButtonItemWasTapped(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
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
            viewController = viewController?.parent
        }
        return nil;
    }
    
    public func addViewControllerToContainer(_ containerView: UIView, viewController: UIViewController?) {
        // Adds a view controller as a child view controller and calls needed life cycle methods
        if let targetViewController = viewController {
            addChild(targetViewController)
            containerView.addSubview(targetViewController.view)
            
            targetViewController.view.snp.remakeConstraints { (make) in
                make.left.equalTo(containerView)
                make.top.equalTo(containerView)
                make.right.equalTo(containerView)
                make.bottom.equalTo(containerView)
            }
            
            targetViewController.didMove(toParent: self)
        }
    }
    
    public func removeViewControllerFromContainer(_ viewController: UIViewController?) {
        // Removes a child view controller and calls needed life cyle methods
        if let targetViewController = viewController {
            targetViewController.willMove(toParent: nil)
            targetViewController.view.removeFromSuperview()
            targetViewController.removeFromParent()
        }
    }
}
