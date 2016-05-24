//
//  WBannerTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

// Alpha doesn't always return a clean number.
public func roundAlpha(alpha: CGFloat) -> CGFloat {
    return CGFloat(round(1000*alpha)/1000)
}

class WBannerSpec: QuickSpec {
    override func spec() {
        describe("WBannerSpec") {
            var subject: UIViewController!
            var bannerView: WBannerView!
            var window: UIWindow!

            let titleMessage = "title"
            let bodyMessage = "body"
            let color1 = UIColor.blackColor()
            let color2 = UIColor.cyanColor()
            let alpha1: CGFloat = 0.2
            let alpha2: CGFloat = 0.9
            var image1: UIImage!
            var image2: UIImage!

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                window.addSubview(subject.view)

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                image1 = UIImage(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource("testImage1", ofType: "png")!)
                image2 = UIImage(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource("testImage2", ofType: "png")!)
            })

            afterEach({
                bannerView.hide()
                bannerView = nil
            })

            let verifyCommonInit = {
                expect(bannerView.titleMessageLabel.numberOfLines).to(equal(1))
                expect(bannerView.titleMessageLabel.textAlignment).to(equal(NSTextAlignment.Left))
                expect(bannerView.titleMessageLabel.font).to(equal(UIFont.systemFontOfSize(16)))
                expect(bannerView.titleMessageLabel.textColor).to(equal(UIColor.whiteColor()))
                expect(bannerView.bodyMessageLabel.numberOfLines).to(equal(2))
                expect(bannerView.bodyMessageLabel.textAlignment).to(equal(NSTextAlignment.Left))
                expect(bannerView.bodyMessageLabel.font).to(equal(UIFont.systemFontOfSize(16)))
                expect(bannerView.bodyMessageLabel.textColor).to(equal(UIColor.whiteColor()))
            }

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    bannerView = WBannerView(rootView: subject.view)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("testsBanner")

                    NSKeyedArchiver.archiveRootObject(bannerView, toFile: locToSave)

                    let bannerView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WBannerView

                    expect(bannerView).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should successfully add and display a banner view with default settings") {
                    bannerView = WBannerView(rootView: subject.view)

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // public properties
                    expect(bannerView.rootView).to(equal(subject.view))
                    expect(bannerView.showDuration).to(equal(BANNER_DEFAULT_SHOW_DURATION))
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.DismissesAfterTime))
                    expect(bannerView.placement).to(equal(WBannerPlacementOptions.Bottom))
                    expect(bannerView.animationDuration).to(equal(BANNER_DEFAULT_ANIMATION_DURATION))
                    expect(bannerView.titleMessage).to(equal(""))
                    expect(bannerView.bodyMessage).to(equal(""))
                    expect(bannerView.titleIcon).to(beNil())
                    expect(bannerView.rightIcon).to(beNil())
                    expect(bannerView.bannerColor).to(equal(UIColor.blackColor()))
                    expect(bannerView.bannerAlpha).to(equal(1.0))
                    expect(bannerView.titleMessageLabel).toNot(beNil())
                    expect(bannerView.bodyMessageLabel).toNot(beNil())
                    expect(bannerView.titleIconImageView).toNot(beNil())
                    expect(bannerView.rightIconImageView).toNot(beNil())
                    expect(roundAlpha(bannerView.rightIconImageView.alpha)).to(equal(1.0))
                    expect(bannerView.backgroundView).toNot(beNil())
                    expect(roundAlpha(bannerView.backgroundView.alpha)).to(equal(1.0))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should not show if there is no root view") {
                    bannerView = WBannerView()

                    expect(bannerView.rootView).to(beNil())

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is still not displayed
                    expect(bannerView.isVisible()).to(beFalsy())
                }
            }

            describe("custom property behavior") {
                it("should use the convenience init with custom properties") {
                    bannerView = WBannerView(rootView: subject.view,
                                             titleMessage: titleMessage,
                                             titleIcon: image1,
                                             bodyMessage: bodyMessage,
                                             rightIcon: image2,
                                             bannerColor: color1,
                                             bannerAlpha: alpha1)
                    bannerView.hideOptions = .NeverDismisses

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.titleMessage).to(equal(titleMessage))
                    expect(bannerView.bodyMessage).to(equal(bodyMessage))
                    expect(bannerView.titleIcon).to(equal(image1))
                    expect(bannerView.rightIcon).to(equal(image2))
                    expect(bannerView.bannerColor).to(equal(color1))
                    expect(bannerView.bannerAlpha).to(equal(alpha1))

                    // public properties
                    expect(bannerView.rootView).to(equal(subject.view))
                    expect(bannerView.showDuration).to(equal(BANNER_DEFAULT_SHOW_DURATION))
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.NeverDismisses))
                    expect(bannerView.placement).to(equal(WBannerPlacementOptions.Bottom))
                    expect(bannerView.animationDuration).to(equal(BANNER_DEFAULT_ANIMATION_DURATION))
                    expect(bannerView.titleMessageLabel).toNot(beNil())
                    expect(bannerView.bodyMessageLabel).toNot(beNil())
                    expect(bannerView.titleIconImageView).toNot(beNil())
                    expect(bannerView.rightIconImageView).toNot(beNil())
                    expect(roundAlpha(bannerView.rightIconImageView.alpha)).to(equal(alpha1))
                    expect(bannerView.backgroundView).toNot(beNil())
                    expect(roundAlpha(bannerView.backgroundView.alpha)).to(equal(alpha1))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should use the basic init and manually set custom properties") {
                    bannerView = WBannerView(rootView: subject.view)

                    bannerView.titleMessage = titleMessage
                    bannerView.bodyMessage = bodyMessage
                    bannerView.titleIcon = image1
                    bannerView.rightIcon = image2
                    bannerView.bannerColor = color2
                    bannerView.bannerAlpha = alpha2
                    bannerView.hideOptions = .NeverDismisses

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.titleMessage).to(equal(titleMessage))
                    expect(bannerView.bodyMessage).to(equal(bodyMessage))
                    expect(bannerView.titleIcon).to(equal(image1))
                    expect(bannerView.rightIcon).to(equal(image2))
                    expect(bannerView.bannerColor).to(equal(color2))
                    expect(bannerView.bannerAlpha).to(equal(alpha2))

                    // public properties
                    expect(bannerView.rootView).to(equal(subject.view))
                    expect(bannerView.showDuration).to(equal(BANNER_DEFAULT_SHOW_DURATION))
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.NeverDismisses))
                    expect(bannerView.placement).to(equal(WBannerPlacementOptions.Bottom))
                    expect(bannerView.animationDuration).to(equal(BANNER_DEFAULT_ANIMATION_DURATION))
                    expect(bannerView.titleMessageLabel).toNot(beNil())
                    expect(bannerView.bodyMessageLabel).toNot(beNil())
                    expect(bannerView.titleIconImageView).toNot(beNil())
                    expect(bannerView.rightIconImageView).toNot(beNil())
                    expect(roundAlpha(bannerView.rightIconImageView.alpha)).to(equal(alpha2))
                    expect(bannerView.backgroundView).toNot(beNil())
                    expect(roundAlpha(bannerView.backgroundView.alpha)).to(equal(alpha2))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should use a tap to dismiss banner") {
                    bannerView = WBannerView(rootView: subject.view)
                    bannerView.hideOptions = WBannerHideOptions.DismissOnTap
                    bannerView.showDuration = 0

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.DismissOnTap))

                    let sender = UITapGestureRecognizer.init()
                    bannerView.bannerWasTapped(sender)

                    // Verify the banner disappears
                    let displayTime = ceil(BANNER_DEFAULT_ANIMATION_DURATION)
                    expect(bannerView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should use a never dismiss banner") {
                    bannerView = WBannerView(rootView: subject.view)
                    bannerView.hideOptions = WBannerHideOptions.NeverDismisses

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.NeverDismisses))

                    let sender = UITapGestureRecognizer.init()
                    bannerView.bannerWasTapped(sender)

                    // Verify the banner does not disappear
                    expect(bannerView.isVisible()).to(beTruthy())
                }

                it("should use a dismiss after time banner") {
                    bannerView = WBannerView(rootView: subject.view)
                    bannerView.hideOptions = WBannerHideOptions.DismissesAfterTime
                    bannerView.showDuration = 2

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.DismissesAfterTime))

                    let sender = UITapGestureRecognizer.init()
                    bannerView.bannerWasTapped(sender)

                    // Verify the banner disappears
                    let displayTime = ceil(BANNER_DEFAULT_ANIMATION_DURATION + 2)
                    expect(bannerView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }

                it("should use a dismiss after time banner and tap to dismiss") {
                    bannerView = WBannerView(rootView: subject.view)
                    bannerView.placement = .Top
                    bannerView.hideOptions = WBannerHideOptions.DismissesAfterTime
                    bannerView.showDuration = 2

                    // Banner is not displayed
                    expect(bannerView.isVisible()).to(beFalsy())

                    bannerView.show()

                    // Banner is displayed
                    expect(bannerView.isVisible()).to(beTruthy())

                    // custom properties
                    expect(bannerView.hideOptions).to(equal(WBannerHideOptions.DismissesAfterTime))

                    let sender = UITapGestureRecognizer.init()
                    bannerView.bannerWasTapped(sender)

                    // Verify the banner disappears
                    let displayTime = ceil(BANNER_DEFAULT_ANIMATION_DURATION)
                    expect(bannerView.isVisible()).toEventually(beFalsy(), timeout: displayTime)
                }
            }
        }
    }
}