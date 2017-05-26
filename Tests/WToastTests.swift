//
//  WToastTests.swift
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

class WToastSpec: QuickSpec {
    override func spec() {
        describe("WToastSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var toastView: WToastView!

            let message1 = "Message 1"
            let message2 = "Message 2"
            let message3 = "Message 3"
            let message4 = "Message 4"

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.main.bounds)
                WToastManager.sharedInstance.rootWindow = window
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                // Init the singleton
                _ = WToastManager.sharedInstance
            })

            afterEach({
                // Reset shared instance
                WToastManager.sharedInstance.currentToast = nil
                toastView = nil
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissesAfterTime))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.black))
                }

                it("should init with coder correctly and verify commonInit") {
                    toastView = WToastView(message: message1)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WToastView")

                    NSKeyedArchiver.archiveRootObject(toastView, toFile: locToSave)

                    let toastView = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WToastView

                    expect(toastView).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should successfully add and display a toast view with default settings") {
                    toastView = WToastView(message: message1)

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    verifyCommonInit()
                    expect(toastView.message).to(equal(message1))
                    expect(toastView.toastAlpha).to(equal(0.7))

                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION + TOAST_DEFAULT_SHOW_DURATION)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                describe("two line toast view") {
                    var twoLineToastView: WToastTwoLineView!

                    let verifyCommonInit = {
                        // Other properties are tested through WToastSpec
                        expect(twoLineToastView.message) == ""
                        expect(twoLineToastView.messageLabel.superview).to(beNil())
                    }

                    it("should init with coder correctly and verify commonInit") {
                        twoLineToastView = WToastTwoLineView(firstLine: "first", secondLine: "second")

                        let path = NSTemporaryDirectory() as NSString
                        let locToSave = path.appendingPathComponent("WToastTwoLineView")

                        NSKeyedArchiver.archiveRootObject(twoLineToastView, toFile: locToSave)

                        let twoLineToastView = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WToastTwoLineView

                        expect(twoLineToastView).toNot(equal(nil))

                        // default settings from commonInit
                        verifyCommonInit()
                    }

                    it("should successfully add and display a toast view with default settings") {
                        twoLineToastView = WToastTwoLineView(firstLine: "first", secondLine: "second")

                        WToastManager.sharedInstance.showToast(twoLineToastView)

                        // Toast is displayed
                        expect(twoLineToastView.isVisible()).to(beTruthy())

                        // public properties
                        verifyCommonInit()
                        expect(twoLineToastView.firstLine) == "first"
                        expect(twoLineToastView.secondLine) == "second"

                        expect(twoLineToastView.firstLabel.frame.height) == (twoLineToastView.frame.size.height / 2) - 8
                        expect(twoLineToastView.secondLabel.frame.height) == (twoLineToastView.frame.size.height / 2) - 8
                        
                        // Verify the toast disappears
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION + TOAST_DEFAULT_SHOW_DURATION)
                        expect(twoLineToastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }
                }

                describe("flexible toast view") {
                    var flexibleToastView: WToastFlexibleView!

                    it("should grow to fit text") {
                        let string = "0\n1\n2\n3\n4\n5\n6\n7\n8\n9"
                        flexibleToastView = WToastFlexibleView(message: string)

                        WToastManager.sharedInstance.showToast(flexibleToastView)

                        expect(flexibleToastView.frame.height) > CGFloat(TOAST_DEFAULT_HEIGHT)
                        expect(flexibleToastView.frame.height) <= CGFloat(flexibleToastView.maxHeight)
                    }
                }
            }

            describe("custom property behavior") {
                context("dismiss behavior") {
                    it("should successfully add and display a toast view that does not automatically dismiss and manually dismisses from the top") {
                        toastView = WToastView(message: message2)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.top

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromTop))
                        expect(toastView.message).to(equal(message2))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())

                        toastView.hide()

                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }

                    it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap from the bottom") {
                        toastView = WToastView(message: message3)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.bottom

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromBottom))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())
                        
                        let sender = UITapGestureRecognizer.init()
                        toastView.toastWasTapped(sender)
                        
                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }

                    it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap from the left starting at the top") {
                        toastView = WToastView(message: message3)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.top
                        toastView.flyInDirection = WToastFlyInDirectionOptions.fromLeft

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromLeft))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())

                        let sender = UITapGestureRecognizer.init()
                        toastView.toastWasTapped(sender)

                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }

                    it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap from the left starting at the bottom") {
                        toastView = WToastView(message: message3)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.bottom
                        toastView.flyInDirection = WToastFlyInDirectionOptions.fromLeft

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromLeft))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())

                        let sender = UITapGestureRecognizer.init()
                        toastView.toastWasTapped(sender)

                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }

                    it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap from the right starting from the top") {
                        toastView = WToastView(message: message3)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.top
                        toastView.flyInDirection = WToastFlyInDirectionOptions.fromRight

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromRight))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())

                        let sender = UITapGestureRecognizer.init()
                        toastView.toastWasTapped(sender)

                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }

                    it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap from the right starting from the bottom") {
                        toastView = WToastView(message: message3)
                        toastView.hideOptions = WToastHideOptions.dismissOnTap
                        toastView.placement = WToastPlacementOptions.bottom
                        toastView.flyInDirection = WToastFlyInDirectionOptions.fromRight

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.fromRight))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.black))
                        expect(toastView.toastAlpha).to(equal(0.7))

                        // Verify the toast is still shown
                        let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION)
                        expect(toastView.isVisible()).to(beTruthy())

                        let sender = UITapGestureRecognizer.init()
                        toastView.toastWasTapped(sender)

                        // Verify the toast disappears
                        expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                    }
                }

                it("should successfully add and display a custom toast view with a set width") {
                    let showDuration = 1.0
                    let image = UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "testImage1", ofType: "png")!)

                    toastView = WToastView()
                    toastView.showDuration = showDuration
                    toastView.toastColor = .red
                    toastView.message = message4
                    toastView.rightIcon = image
                    toastView.toastAlpha = 0.6
                    toastView.width = 200

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissesAfterTime))
                    expect(toastView.message).to(equal(message4))
                    expect(toastView.rightIcon).to(equal(image))
                    expect(toastView.rightIconImageView.image).to(equal(image))
                    expect(toastView.toastColor).to(equal(UIColor.red))
                    expect(toastView.toastAlpha).to(equal(0.6))
                    expect(toastView.width).to(equal(200))
                    
                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION + showDuration)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should change to DismissOnTap if the duration is set to 0") {
                    let showDuration = 0.0

                    toastView = WToastView()
                    toastView.hideOptions = WToastHideOptions.dismissesAfterTime
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                }

                it("should change to DismissOnTap if the duration is set to a negative number") {
                    let showDuration = -99999.0

                    toastView = WToastView()
                    toastView.hideOptions = WToastHideOptions.dismissesAfterTime
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.dismissOnTap))
                }
            }
        }
    }
}
