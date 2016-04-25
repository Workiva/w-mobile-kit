//
//  WUserLogoViewTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WUserLogoViewTests: QuickSpec {
    override func spec() {
        describe("WUserLogoViewSpec") {
            var subject: UIViewController!
            var userLogoView: WUserLogoView!

            // Usernames
            let name1 = "Gambit"
            let name2 = "Jessica Jones"
            let name3 = "Peter Benjamin Parker"
            let name4 = "Anthony Tony Edward Stark"

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            describe("when app has been init") {
                it("should successfully add and display a user logo view with default settings") {
                    userLogoView = WUserLogoView(name1)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.initialsLabel.text).to(equal("G"))
                    expect(userLogoView.name).to(equal(name1))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                }

                it("should successfully add and display a user logo view with custom settings") {
                    userLogoView = WUserLogoView()

                    // Custom Settings
                    userLogoView.bounds = CGRectMake(0, 0, 100, 100)
                    userLogoView.color = .cyanColor()
                    userLogoView.name = name2
                    userLogoView.lineWidth = 2.0

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(100)
                        make.height.equalTo(100)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.bounds).to(equal(CGRectMake(0, 0, 100, 100)))
                    expect(userLogoView.color).to(equal(UIColor.cyanColor()))
                    expect(userLogoView.name).to(equal(name2))
                    expect(userLogoView.initialsLabel.text).to(equal("JJ"))
                    expect(userLogoView.lineWidth).to(equal(2.0))
                }

                it("should successfully add and display a user logo view with a three word name") {
                    userLogoView = WUserLogoView(name3)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.initialsLabel.text).to(equal("PBP"))
                    expect(userLogoView.name).to(equal(name3))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                }

                it("should successfully add and display a user logo view with a four word name") {
                    userLogoView = WUserLogoView(name4)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.initialsLabel.text).to(equal("ATES"))
                    expect(userLogoView.name).to(equal(name4))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                }
            }

            describe("mapping name to color") {
                it("should always map to the same color for the same name") {
                    let color1 = WUserLogoView.mapNameToColor(name1)
                    let color2 = WUserLogoView.mapNameToColor(name1)

                    expect(color1).to(equal(color2))

                    let color3 = WUserLogoView.mapNameToColor(name2)
                    let color4 = WUserLogoView.mapNameToColor(name2)

                    expect(color3).to(equal(color4))

                    let color5 = WUserLogoView.mapNameToColor(name3)
                    let color6 = WUserLogoView.mapNameToColor(name3)

                    expect(color5).to(equal(color6))

                    let color7 = WUserLogoView.mapNameToColor(name4)
                    let color8 = WUserLogoView.mapNameToColor(name4)

                    expect(color7).to(equal(color8))
                }
            }
        }
    }
}