//
//  WSideMenuVCTests.swift
//  WSideMenuVCTests

import Quick
import Nimble
@testable import WMobileKit

class WSideMenuVCSpec: QuickSpec {
    override func spec() {
        describe("WSideMenuVCSpec") {
            var subject: WSideMenuVC!
            var mainVC: UIViewController!
            var leftSideMenuVC: UIViewController!

            beforeEach({
                mainVC = UIViewController()
                leftSideMenuVC = UIViewController()

                subject = WSideMenuVC(mainViewController: mainVC, leftSideMenuViewController: leftSideMenuVC)

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            describe("when app has been init") {
                it("should have the correct properties set") {
                    // public properties
                    expect(subject.mainViewController).to(equal(mainVC))
                    expect(subject.leftSideMenuViewController).to(equal(leftSideMenuVC))
                    expect(subject.options).toNot(beNil())

                    // internal properties
                    expect(subject.menuState).to(equal(WSideMenuState.Closed))
                    expect(subject.statusBarHidden).to(beFalsy())

                    expect(UINavigationBar.appearance().translucent).to(beFalsy())
                }
            }

            describe("side menu actions") {
                it("should open the side menu") {
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                }

                it("should close the side menu") {
                    subject.closeSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                }

                it("should toggle the side menu back and forth") {
                    // Start open
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())

                    // Close
                    subject.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())

                    // Open
                    subject.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                }
            }

            describe("status bar") {
                it("should return default if no options are set") {
                    subject.options = nil

                    expect(subject.preferredStatusBarStyle()).to(equal(UIStatusBarStyle.Default))
                }

                it("should return the option's style if options are set") {
                    var newOptions = WSideMenuOptions()
                    newOptions.statusBarStyle = UIStatusBarStyle.LightContent

                    subject.options = newOptions

                    expect(subject.preferredStatusBarStyle()).to(equal(UIStatusBarStyle.LightContent))
                }
            }

            describe("controller management") {
                var newViewController: UIViewController!
                //var containerView: UIView!

                beforeEach({ 
                    newViewController = UIViewController()
                  //  containerView = UIView()
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

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())

                    subject.mainContainerViewWasTapped(subject)

                    // Now closed
                    expect(subject.menuState).toEventually(equal(WSideMenuState.Closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())
                }
            }

            describe("WSideMenuContentVC") {
                var sideMenuContentVC: WSideMenuContentVC!

                beforeEach({
                    sideMenuContentVC = WSideMenuContentVC()

                    subject.addViewControllerToContainer(subject.mainContainerView, viewController: sideMenuContentVC)
                })

                afterEach({ 
                    subject.removeViewControllerFromContainer(sideMenuContentVC)
                })

                it("should return the side menu controller for the content VC") {
                    expect(sideMenuContentVC.sideMenuController()).to(equal(subject))
                }

                it("should toggle the side menu") {
                    // Start open
                    subject.openSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())

                    // Close
                    sideMenuContentVC.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Closed), timeout: 1)
                    expect(subject.statusBarHidden).to(beFalsy())

                    // Open
                    sideMenuContentVC.toggleSideMenu()

                    expect(subject.menuState).toEventually(equal(WSideMenuState.Open), timeout: 1)
                    expect(subject.statusBarHidden).to(beTruthy())
                }

                it("should respond to the back button item being tapped") {
                    sideMenuContentVC.backButtonItemWasTapped(subject)
                }
            }
        }
    }
}