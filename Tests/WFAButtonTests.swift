
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

                window = UIWindow(frame: UIScreen.main.bounds)
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
                expect(button.buttonColor) == UIColor.blue
            }

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WFAButton")

                    NSKeyedArchiver.archiveRootObject(button, toFile: locToSave)

                    let button = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WFAButton

                    expect(button).toNot(beNil())

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
                    recognizer.testState = .began

                    button.buttonWasLongPressed(recognizer: recognizer)
                    expect(button.darkOverlay.isHidden) == false
                }

                it("should high dark overlay when done pressing") {
                    recognizer.testState = .ended

                    button.buttonWasLongPressed(recognizer: recognizer)
                    expect(button.darkOverlay.isHidden) == true
                }

                it("should hide dark overlay when dragged beyond buffer") {
                    recognizer.testState = .began

                    button.buttonWasLongPressed(recognizer: recognizer)
                    expect(button.darkOverlay.isHidden) == false

                    recognizer.returnPoint = CGPoint(x: -11, y: 0)
                    recognizer.testState = .changed

                    button.buttonWasLongPressed(recognizer: recognizer)
                    expect(button.darkOverlay.isHidden) == true

                    recognizer.returnPoint = CGPoint.zero
                    recognizer.testState = .changed

                    button.buttonWasLongPressed(recognizer: recognizer)
                    expect(button.darkOverlay.isHidden) == false
                }
            }
        }
    }
}
