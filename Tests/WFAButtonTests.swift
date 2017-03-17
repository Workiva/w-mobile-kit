//
//  WFAButtonTests.swift
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

class WFAButtonSpec: QuickSpec {
    override func spec() {
        describe("WFAButtonSpec") {
            var subject: UIViewController!
            var button: WFAButton!
            var window: UIWindow!

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                button = WFAButton()

                window.addSubview(subject.view)
                subject.view.addSubview(button)

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            let verifyCommonInit = {
                // All views added programatically
                expect(button.subviews.contains(button.buttonBackgroundView)).to(beTruthy())
                expect(button.subviews.contains(button.imageView)).to(beTruthy())
                expect(button.subviews.contains(button.darkOverlay)).to(beTruthy())

                // Custom properties
                expect(button.dragBuffer) == 10
                expect(button.buttonColor) == UIColor.blueColor()
            }

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WFAButton")

                    NSKeyedArchiver.archiveRootObject(button, toFile: locToSave)

                    let button = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WFAButton

                    expect(button).toNot(equal(nil))

                    // default settings from commonInit and default public properties
                    verifyCommonInit()
                }

                it("should set icon properly") {
                    let image = UIImage()
                    button.icon = image
                    expect(button.imageView.image) == image
                }
            }

            describe("detecting long press") {
                var recognizer: UILongPressGestureRecognizerMock!

                beforeEach({
                    recognizer = UILongPressGestureRecognizerMock()
                })

                it("should reveal dark overlay when pressed") {
                    recognizer.testState = .Began

                    button.buttonWasLongPressed(recognizer)
                    expect(button.darkOverlay.hidden) == false
                }

                it("should high dark overlay when done pressing") {
                    recognizer.testState = .Ended

                    button.buttonWasLongPressed(recognizer)
                    expect(button.darkOverlay.hidden) == true
                }

                it("should hide dark overlay when dragged beyond buffer") {
                    recognizer.testState = .Began

                    button.buttonWasLongPressed(recognizer)
                    expect(button.darkOverlay.hidden) == false

                    recognizer.returnPoint = CGPoint(x: -11, y: 0)
                    recognizer.testState = .Changed

                    button.buttonWasLongPressed(recognizer)
                    expect(button.darkOverlay.hidden) == true

                    recognizer.returnPoint = CGPointZero
                    recognizer.testState = .Changed

                    button.buttonWasLongPressed(recognizer)
                    expect(button.darkOverlay.hidden) == false
                }
            }
        }
    }
}
