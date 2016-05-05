//
//  WToastTests.swift
//  WMobileKit

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

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                WToastManager.sharedInstance.rootWindow = window
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                // Init the singleton
                WToastManager.sharedInstance
            })

            afterEach({
                // Reset shared instance
                WToastManager.sharedInstance.currentToast = nil
                toastView = nil
            })

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    toastView = WToastView(message: message1)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WToastView")

                    NSKeyedArchiver.archiveRootObject(toastView, toFile: locToSave)

                    let toastView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WToastView

                    expect(toastView).toNot(equal(nil))

                    // default settings from commonInit
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))
                }

                it("should successfully add and display a toast view with default settings") {
                    toastView = WToastView(message: message1)

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.message).to(equal(message1))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))
                    expect(toastView.toastAlpha).to(equal(0.7))

                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION + TOAST_DEFAULT_SHOW_DURATION)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }
            }

            describe("custom property behavior") {
                context("dismiss behavior") {
                    it("should successfully add and display a toast view that does not automatically dismiss and manually dismisses from the top") {
                        toastView = WToastView(message: message2)
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Top

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromTop))
                        expect(toastView.message).to(equal(message2))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Bottom

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromBottom))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Top
                        toastView.flyInDirection = WToastFlyInDirectionOptions.FromLeft

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromLeft))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Bottom
                        toastView.flyInDirection = WToastFlyInDirectionOptions.FromLeft

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromLeft))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Top
                        toastView.flyInDirection = WToastFlyInDirectionOptions.FromRight

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Top))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromRight))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                        toastView.hideOptions = WToastHideOptions.DismissOnTap
                        toastView.placement = WToastPlacementOptions.Bottom
                        toastView.flyInDirection = WToastFlyInDirectionOptions.FromRight

                        WToastManager.sharedInstance.showToast(toastView)

                        // Toast is displayed
                        expect(toastView.isVisible()).to(beTruthy())

                        // public properties
                        expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                        expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                        expect(toastView.placement).to(equal(WToastPlacementOptions.Bottom))
                        expect(toastView.flyInDirection).to(equal(WToastFlyInDirectionOptions.FromRight))
                        expect(toastView.message).to(equal(message3))
                        expect(toastView.rightIcon).to(beNil())
                        expect(toastView.toastColor).to(equal(UIColor.blackColor()))
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
                    let image = UIImage(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource("testImage1", ofType: "png")!)

                    toastView = WToastView()
                    toastView.showDuration = showDuration
                    toastView.toastColor = .redColor()
                    toastView.message = message4
                    toastView.rightIcon = image
                    toastView.toastAlpha = 0.6
                    toastView.width = 200

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.message).to(equal(message4))
                    expect(toastView.rightIcon).to(equal(image))
                    expect(toastView.rightIconImageView.image).to(equal(image))
                    expect(toastView.toastColor).to(equal(UIColor.redColor()))
                    expect(toastView.toastAlpha).to(equal(0.6))
                    expect(toastView.width).to(equal(200))
                    
                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_DEFAULT_ANIMATION_DURATION + showDuration)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should change to DismissOnTap if the duration is set to 0") {
                    let showDuration = 0.0

                    toastView = WToastView()
                    toastView.hideOptions = WToastHideOptions.DismissesAfterTime
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                }

                it("should change to DismissOnTap if the duration is set to a negative number") {
                    let showDuration = -99999.0

                    toastView = WToastView()
                    toastView.hideOptions = WToastHideOptions.DismissesAfterTime
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.hideOptions).to(equal(WToastHideOptions.DismissOnTap))
                }
            }
        }
    }
}