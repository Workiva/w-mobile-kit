//
//  WSideMenuVCTests.swift
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

import Quick
import Nimble
@testable import WMobileKit

class WSideMenuVCSpec: QuickSpec {
    override func spec() {
        describe("WSideMenuVCSpec") {
            var subject: WSideMenuVC!
            var window: UIWindow!
            var mainNC: UINavigationController!
            var mainVC: UIViewController!
            var leftSideMenuVC: UIViewController!

            beforeEach({
                mainVC = UIViewController()
                leftSideMenuVC = UIViewController()

                subject = WSideMenuVC(mainViewController: mainVC, leftSideMenuViewController: leftSideMenuVC)

                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject

                mainNC = UINavigationController(rootViewController: subject)

                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = mainNC

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WSideMenuVC")

                    NSKeyedArchiver.archiveRootObject(subject, toFile: locToSave)

                    let sideMenuVC = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WSideMenuVC

                    expect(sideMenuVC).toNot(beNil())
                }

                it("should have the correct properties set") {
                    // public properties
                    expect(subject.mainViewController).to(equal(mainVC))
                    expect(subject.leftSideMenuViewController).to(equal(leftSideMenuVC))
                    expect(subject.options).toNot(beNil())

                    // internal properties
                    expect(subject.menuState).to(equal(WSideMenuState.closed))
                    expect(subject.statusBarHidden).to(beFalsy())

                    expect(UINavigationBar.appearance().isTranslucent).to(beFalsy())
                }
            }

            describe("side menu actions") {
                it("should open the side menu") {
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                }

                it("should close the side menu") {
                    subject.closeSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                }

                it("should toggle the side menu back and forth") {
                    // Start open
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                    expect(subject.backgroundTapView.isHidden) == false

                    // Close
                    subject.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                    expect(subject.backgroundTapView.isHidden) == true

                    // Open
                    subject.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                    expect(subject.backgroundTapView.isHidden) == false
                }
            }

            describe("status bar") {
                it("should return default if no options are set") {
                    subject.options = nil

                    expect(subject.preferredStatusBarStyle).to(equal(UIStatusBarStyle.default))
                }

                it("should return the option's style if options are set") {
                    var newOptions = WSideMenuOptions()
                    newOptions.statusBarStyle = UIStatusBarStyle.lightContent

                    subject.options = newOptions

                    expect(subject.preferredStatusBarStyle).to(equal(UIStatusBarStyle.lightContent))
                }
            }

            describe("controller management") {
                var newViewController: UIViewController!

                beforeEach({ 
                    newViewController = UIViewController()
                })

                it("should change to the new main view controller") {
                    expect(subject.mainViewController).to(equal(mainVC))

                    subject.changeMainViewController(newViewController)

                    expect(subject.mainViewController).to(equal(newViewController))
                }

                it("should add and remove new view controller to container") {
                    expect(subject.mainContainerView.subviews).toNot(contain(newViewController.view))

                    subject.addViewControllerToContainer(subject.mainContainerView, viewController: newViewController)

                    expect(subject.mainContainerView.subviews).to(contain(newViewController.view))

                    subject.removeViewControllerFromContainer(newViewController)

                    expect(subject.mainContainerView.subviews).toNot(contain(newViewController.view))
                }

                it("should close the side menu if the main container view was tapped") {
                    // Start open
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                    expect(subject.backgroundTapView.isHidden) == false

                    subject.backgroundWasTapped(subject)

                    // Now closed
                    expect(subject.menuState).toEventually(equal(WSideMenuState.closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                    expect(subject.backgroundTapView.isHidden) == true
                }
            }

            describe("WSideMenuContentVC") {
                var subNavController: UINavigationController!
                var sideMenuContentVC: WSideMenuContentVC!

                beforeEach({
                    sideMenuContentVC = WSideMenuContentVC()
                    subNavController = UINavigationController(rootViewController: sideMenuContentVC)

                    subject.changeMainViewController(subNavController)
                })

                it("should return the side menu controller for the content VC") {
                    expect(sideMenuContentVC.sideMenuController()).to(equal(subject))
                }

                it("should toggle the side menu") {
                    // Start open
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                    expect(subject.backgroundTapView.isHidden) == false

                    // Close
                    sideMenuContentVC.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                    expect(subject.backgroundTapView.isHidden) == true

                    // Open
                    sideMenuContentVC.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                    expect(subject.backgroundTapView.isHidden) == false
                }

                it("should respond to the back button item being tapped") {
                    sideMenuContentVC.backButtonItemWasTapped(subject)
                }

                it("should add side menu buttons for a content VC without a drawer icon") {
                    subject.options?.drawerIcon = nil

                    sideMenuContentVC.addWSideMenuButtons()

                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.title) == "Toggle"
                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.image).to(beNil())
                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.style) == .plain
                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.action) == #selector(WSideMenuContentVC.toggleSideMenu)
                }

                it("should add side menu buttons for a content VC with a drawer icon") {
                    let image = UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "testImage1", ofType: "png")!)

                    subject.options?.drawerIcon = image

                    sideMenuContentVC.addWSideMenuButtons()

                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.image).toNot(beNil())
                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.style) == .plain
                    expect(sideMenuContentVC.navigationItem.leftBarButtonItem?.action) == #selector(WSideMenuContentVC.toggleSideMenu)
                }

                it("should add side menu buttons for a content VC with a nav controller with multiple controllers no back icon") {
                    let additionalController = WSideMenuContentVC()
                    subNavController.pushViewController(additionalController, animated: false)

                    subject.options?.drawerIcon = nil
                    subject.options?.backIcon = nil

                    additionalController.addWSideMenuButtons()

                    expect(additionalController.navigationItem.leftBarButtonItems?[0].title) == "Back"
                    expect(additionalController.navigationItem.leftBarButtonItems?[0].style) == .plain
                    expect(additionalController.navigationItem.leftBarButtonItems?[0].action) == #selector(WSideMenuContentVC.backButtonItemWasTapped(_:))

                    expect(additionalController.navigationItem.leftBarButtonItems?[1].title) == "Toggle"
                    expect(additionalController.navigationItem.leftBarButtonItems?[1].style) == .plain
                    expect(additionalController.navigationItem.leftBarButtonItems?[1].action) == #selector(WSideMenuContentVC.toggleSideMenu)
                    expect(additionalController.navigationItem.leftBarButtonItems?[1].imageInsets) == UIEdgeInsetsMake(0, -20, 0, 20)
                }

                it("should have correct padding between menu and back icons") {
                    let additionalController = WSideMenuContentVC()
                    subNavController.pushViewController(additionalController, animated: false)

                    subject.options?.drawerIcon = nil
                    subject.options?.backIcon = nil

                    additionalController.paddingBetweenBackAndMenuIcons = 10

                    additionalController.addWSideMenuButtons()

                    expect(additionalController.navigationItem.leftBarButtonItems?[1].title) == "Toggle"
                    expect(additionalController.navigationItem.leftBarButtonItems?[1].imageInsets) == UIEdgeInsetsMake(0, -10, 0, 10)
                }
            }
        }
    }
}
