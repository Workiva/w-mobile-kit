//
//  WThemeTests.swift
//  WThemeTests

import Quick
import Nimble
@testable import WMobileKit

class WThemeSpec: QuickSpec {
    override func spec() {
        describe("WThemeSpec") {
            beforeEach({
                // Init the theme manager
                WThemeManager.sharedInstance
            })

            afterEach({
                // reset the theme manager to the default theme
                WThemeManager.sharedInstance.currentTheme = DefaultTheme()
            })

            describe("when theme manager has been init"){
                it("should return a default theme if current theme not set") {
                    let currentTheme = WThemeManager.sharedInstance.currentTheme

                    expect(currentTheme is DefaultTheme).to(beTruthy())
                }

                it("should not return a custom theme if theme is not set") {
                    let currentTheme = WThemeManager.sharedInstance.currentTheme

                    expect(currentTheme is CustomTheme).to(beFalsy())
                }

                it("should return a custom theme if current theme is set to custom") {
                    WThemeManager.sharedInstance.currentTheme = CustomTheme()
                    let currentTheme = WThemeManager.sharedInstance.currentTheme

                    expect(currentTheme is CustomTheme).to(beTruthy())
                }

                it("should successfully override colors for a custom green theme when set to the current theme") {
                    WThemeManager.sharedInstance.currentTheme = GreenTheme()
                    let currentTheme = WThemeManager.sharedInstance.currentTheme

                    expect(currentTheme.navigationBarColor).to(equal(UIColor(hex: 0x42AD48)))
                    expect(currentTheme.pagingSelectorControlColor).to(equal(UIColor(hex: 0x6ABD5E)))
                }
            }
        }
    }
}