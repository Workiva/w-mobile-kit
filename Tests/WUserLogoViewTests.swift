//
//  WUserLogoViewTests.swift
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

import Quick
import Nimble
@testable import WMobileKit

class WUserLogoViewTests: QuickSpec {
    override func spec() {
        describe("WUserLogoViewSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var userLogoView: WUserLogoView!

            // Usernames
            let name1 = "Gambit"
            let name2 = "Jessica Jones"
            let name3 = "Peter Benjamin Parker"
            let name4 = "Anthony Tony Edward Stark"
            let name5 = "Natasha Romanova"
            let name6 = "Matt Murdock"
            let name7 = "Homer Simpson"

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                userLogoView = nil
            })

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    userLogoView = WUserLogoView(name1)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WUserLogoView")

                    NSKeyedArchiver.archiveRootObject(userLogoView, toFile: locToSave)

                    let object = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WUserLogoView

                    expect(object).toNot(equal(nil))

                    // default settings from commonInit
                }

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
                    userLogoView.initialsLimit = 4

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

                it("should successfully add and display a user logo view with an empty name") {
                    userLogoView = WUserLogoView("")

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.initialsLabel.text).to(equal("?"))
                    expect(userLogoView.name).to(equal(""))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                    expect(userLogoView.initialsLabel.textColor) == UIColor.grayColor()
                }

                it("should work correctly if the initials label has been removed") {
                    userLogoView = WUserLogoView(name5)
                    userLogoView.initialsLimit = 1
                    userLogoView.initialsLabel.removeFromSuperview()
                    userLogoView.bounds = CGRectMake(0, 0, 80, 80)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.initialsLabel.text).to(equal("N"))
                    expect(userLogoView.name).to(equal(name5))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                }
                
                it("should successfully add and display a user's profile image via URL") {
                    userLogoView = WUserLogoView(name7)
                    userLogoView.initialsLimit = 2
                    userLogoView.initialsLabel.removeFromSuperview()
                    userLogoView.bounds = CGRectMake(0, 0, 80, 80)
                    userLogoView.imageURL = "http://www.simpsoncrazy.com/content/pictures/homer/HomerSimpson3.gif"
                    
                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }
                    
                    subject.view.layoutIfNeeded()
                    
                    // public properties
                    userLogoView.setNeedsDisplay()
                    expect(userLogoView.name).to(equal(name7))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                    expect(userLogoView.initialsLabel.hidden).toEventually(beTruthy())
                    expect(userLogoView.imageData).toEventuallyNot(beNil())
                }    
                
                it("should continue to show the user's initials when not able to load the image URL") {
                    userLogoView = WUserLogoView(name7)
                    userLogoView.initialsLimit = 2
                    userLogoView.initialsLabel.removeFromSuperview()
                    userLogoView.bounds = CGRectMake(0, 0, 80, 80)
                    userLogoView.imageURL = "http://not.a.valid.domain/image.gif"
                    
                    subject.view.addSubview(userLogoView)
                    userLogoView.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }
                    
                    subject.view.layoutIfNeeded()
                    
                    // public properties
                    expect(userLogoView.imageURL).toEventually(beNil())
                    expect(userLogoView.initialsLabel.hidden) == false
                    expect(userLogoView.name).to(equal(name7))
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

                    let color9 = WUserLogoView.mapNameToColor(name5)
                    let color10 = WUserLogoView.mapNameToColor(name5)

                    expect(color9).to(equal(color10))

                    let color11 = WUserLogoView.mapNameToColor(name6)
                    let color12 = WUserLogoView.mapNameToColor(name6)

                    expect(color11).to(equal(color12))
                }
            }
        }
    }
}