//
//  WUserLogoViewTests.swift
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

                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                userLogoView = nil
            })

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    userLogoView = WUserLogoView(name: name1)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WUserLogoView")

                    NSKeyedArchiver.archiveRootObject(userLogoView, toFile: locToSave)

                    let object = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WUserLogoView

                    expect(object).toNot(beNil())

                    // default settings from commonInit
                }

                it("should successfully add and display a user logo view with default settings") {
                    userLogoView = WUserLogoView(name: name1)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
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
                    userLogoView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
                    userLogoView.color = .cyan
                    userLogoView.name = name2
                    userLogoView.lineWidth = 2.0

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(100)
                        make.height.equalTo(100)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(userLogoView.bounds).to(equal(CGRect(x: 0, y: 0, width: 100, height: 100)))
                    expect(userLogoView.color).to(equal(UIColor.cyan))
                    expect(userLogoView.name).to(equal(name2))
                    expect(userLogoView.initialsLabel.text).to(equal("JJ"))
                    expect(userLogoView.lineWidth).to(equal(2.0))
                }

                it("should successfully add and display a user logo view with a three word name") {
                    userLogoView = WUserLogoView(name: name3)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
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
                    userLogoView = WUserLogoView(name: name4)
                    userLogoView.initialsLimit = 4

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
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
                    userLogoView = WUserLogoView(name: "")

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
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
                    expect(userLogoView.initialsLabel.textColor) == UIColor.gray
                }

                it("should work correctly if the initials label has been removed") {
                    userLogoView = WUserLogoView(name: name5)
                    userLogoView.initialsLimit = 1
                    userLogoView.initialsLabel.removeFromSuperview()
                    userLogoView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)

                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
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
                    userLogoView = WUserLogoView(name: name7)
                    userLogoView.initialsLimit = 2
                    userLogoView.initialsLabel.removeFromSuperview()
                    userLogoView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
                    userLogoView.imageURL = "https://avatars0.githubusercontent.com/u/1087529?v=3&s=200"
                    
                    subject.view.addSubview(userLogoView)
                    userLogoView.snp.makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }
                                        
                    // public properties
                    userLogoView.setupUI()
                    expect(userLogoView.name).to(equal(name7))
                    expect(userLogoView.lineWidth).to(equal(1.0))
                    expect(userLogoView.initialsLabel.isHidden).toEventually(beTruthy(), timeout: 3.0)
                    expect(userLogoView.imageURL).toEventuallyNot(beNil(), timeout: 3.0)
                    expect(userLogoView.mappedColor) == UIColor(hex: 0xE3E3E3)
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

            describe("type and shape") {
                let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                let center = CGPoint(x: frame.width / 2, y: frame.height / 2)

                beforeEach({
                    userLogoView = WUserLogoView()
                    userLogoView.frame = frame
                    userLogoView.name = name1
                })

                it("should use default values") {
                    expect(userLogoView.type) == Type.Outline
                    expect(userLogoView.shape) == Shape.Circle
                    expect(userLogoView.cornerRadius) == 3
                }

                it("should create the correct shape") {
                    userLogoView.shape = .Circle
                    expect(userLogoView.shapeLayer.path) == UIBezierPath(arcCenter: center, radius: frame.width / 2 - 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath

                    userLogoView.shape = .Square
                    expect(userLogoView.shapeLayer.path) == UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: userLogoView.cornerRadius).cgPath
                }

                it("should set fill and font for correct type") {
                    userLogoView.type = .Outline

                    expect(userLogoView.initialsLabel.textColor) == userLogoView.mappedColor
                    expect(userLogoView.shapeLayer.fillColor) == UIColor.clear.cgColor

                    userLogoView.type = .Filled

                    expect(userLogoView.initialsLabel.textColor) == UIColor.white
                    expect(userLogoView.shapeLayer.fillColor) == userLogoView.mappedColor.cgColor
                }

                it("should set correct corner radius") {
                    userLogoView.shape = .Square
                    userLogoView.imageURL = "https://avatars0.githubusercontent.com/u/1087529?v=3&s=200"

                    let cornerRadius: CGFloat = 5

                    userLogoView.cornerRadius = cornerRadius

                    expect(userLogoView.profileImageView.layer.cornerRadius) == cornerRadius
                }
            }
        }
    }
}
