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
            var toastView: WToastView!

            let message1 = "Message 1"
            let message2 = "Message 2"
            let message3 = "Message 3"
            let message4 = "Message 4"

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
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
            })

            describe("when app has been init") {
                it("should successfully add and display a toast view with default settings") {
                    toastView = WToastView(message: message1)

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.message).to(equal(message1))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))

                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_ANIMATION_DURATION + TOAST_DEFAULT_SHOW_DURATION)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should successfully add and display a toast view that does not automatically dismiss and manually dismisses") {
                    toastView = WToastView(message: message2)
                    toastView.toastOptions = WToastHideOptions.DismissOnTap

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissOnTap))
                    expect(toastView.message).to(equal(message2))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))

                    // Verify the toast is still shown
                    let displayTime = ceil(TOAST_ANIMATION_DURATION)
                    expect(toastView.isVisible()).to(beTruthy())

                    toastView.hide()

                    // Verify the toast disappears
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should successfully add and display a toast view that does not automatically dismiss and dismisses on tap") {
                    toastView = WToastView(message: message3)
                    toastView.toastOptions = WToastHideOptions.DismissOnTap

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissOnTap))
                    expect(toastView.message).to(equal(message3))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))

                    // Verify the toast is still shown
                    let displayTime = ceil(TOAST_ANIMATION_DURATION)
                    expect(toastView.isVisible()).to(beTruthy())

                    let sender = UITapGestureRecognizer.init()
                    toastView.toastWasTapped(sender)

                    // Verify the toast disappears
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should successfully add and display a custom toast view") {
                    let showDuration = 1.0
                    let path = NSBundle(forClass: self.dynamicType).pathForResource("testImage1", ofType: "png")!
                    let image = UIImage(contentsOfFile: path)

                    toastView = WToastView()
                    toastView.showDuration = showDuration
                    toastView.toastColor = UIColor.redColor()
                    toastView.message = message4
                    toastView.rightIcon = image

                    WToastManager.sharedInstance.showToast(toastView)

                    // Toast is displayed
                    expect(toastView.isVisible()).to(beTruthy())

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.message).to(equal(message4))
                    expect(toastView.rightIcon).to(equal(image))
                    expect(toastView.rightIconImageView.image).to(equal(image))
                    expect(toastView.toastColor).to(equal(UIColor.redColor()))

                    // Verify the toast disappears
                    let displayTime = ceil(TOAST_ANIMATION_DURATION + showDuration)
                    expect(toastView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }
                
                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("testsToast")
                    
                    NSKeyedArchiver.archiveRootObject(toastView, toFile: locToSave)
                    
                    let toastView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WToastView
                    
                    expect(toastView).toNot(equal(nil))
                    
                    // default settings from commonInit
                    expect(toastView.showDuration).to(equal(TOAST_DEFAULT_SHOW_DURATION))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    expect(toastView.rightIcon).to(beNil())
                    expect(toastView.toastColor).to(equal(UIColor.blackColor()))
                }
            }

            describe("custom property behavior") {
                it("should change to DismissOnTap if the duration is set to 0") {
                    let showDuration = 0.0

                    toastView = WToastView()
                    toastView.toastOptions = WToastHideOptions.DismissesAfterTime
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissOnTap))
                }

                it("should change to DismissOnTap if the duration is set to a negative number") {
                    let showDuration = -99999.0

                    toastView = WToastView()
                    toastView.toastOptions = WToastHideOptions.DismissesAfterTime
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissesAfterTime))
                    toastView.showDuration = showDuration

                    // public properties
                    expect(toastView.showDuration).to(equal(showDuration))
                    expect(toastView.toastOptions).to(equal(WToastHideOptions.DismissOnTap))
                }
            }
        }
    }
}