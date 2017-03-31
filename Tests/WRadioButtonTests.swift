//
//  WRadioButtonTests.swift
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

class WRadioButtonSpec: QuickSpec {
    override func spec() {
        describe("WRadioButtonSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var radioButton: WRadioButton!
            
            beforeEach({
                subject = UIViewController()
                
                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                radioButton = nil
            })

            let verifyCommonInit = {
                expect(radioButton.isSelected) == false
                expect(radioButton.bounds) == CGRect(origin: radioButton.bounds.origin,
                    size: CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2))
                expect(radioButton.radioCircle.clipsToBounds) == true
                expect(radioButton.indicatorView.clipsToBounds) == true
                expect(radioButton.groupID) == 0
                expect(radioButton.buttonID) == 0

                expect(radioButton.buttonColor) == UIColor.white
                expect(radioButton.highlightColor) == UIColor.gray
                expect(radioButton.indicatorColor) == UIColor.darkGray
                expect(radioButton.borderColorNotSelected) == UIColor.lightGray
                expect(radioButton.borderColorSelected) == UIColor.lightGray

                expect(radioButton.borderWidth) == 2.0
                expect(radioButton.buttonRadius) == 12.0
                expect(radioButton.indicatorRadius) == 6
                expect(radioButton.animationTime) == 0.2
                expect(radioButton.indicatorView.alpha) == 0.0
                expect(radioButton.radioCircle.layer.cornerRadius) == radioButton.radioCircle.frame.size.height / 2
                expect(radioButton.indicatorView.layer.cornerRadius) == radioButton.indicatorView.frame.size.height / 2
            }

            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WRadioButton")
                    
                    NSKeyedArchiver.archiveRootObject(radioButton, toFile: locToSave)
                    
                    let radioButton = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WRadioButton
                    
                    expect(radioButton).toNot(equal(nil))
                    
                    // default settings from commonInit and default var values
                    verifyCommonInit()
                }
                
                it("should init and setupUI properly without initializer parameters") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)
                    radioButton.setupUI()
                    
                    // default settings from commonInit/setupUI
                    verifyCommonInit()
                }
                
                it("should init properly with true initializer parameter") {
                    radioButton = WRadioButton(true)
                    subject.view.addSubview(radioButton)
                    radioButton.setupUI()
                    
                    // true init changes
                    expect(radioButton.isSelected) == true
                    expect(radioButton.indicatorView.alpha) == 1.0
                }

                it("should have correct intrinsic size") {
                    radioButton = WRadioButton()
                    
                    expect(radioButton.intrinsicContentSize) == CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2)
                }
            }
            
            describe("setting custom values for vars") {
                it("should reflect changed vars properly") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)

                    radioButton.groupID = 1
                    radioButton.buttonID = 2

                    radioButton.buttonColor = UIColor.red
                    radioButton.highlightColor = UIColor.blue
                    radioButton.indicatorColor = UIColor.green
                    radioButton.borderColorNotSelected = UIColor.purple
                    radioButton.borderColorSelected = UIColor.blue

                    radioButton.borderWidth = 4
                    radioButton.buttonRadius = 14
                    radioButton.indicatorRadius = 7
                    radioButton.borderWidth = 4
                    radioButton.animationTime = 0.1
                    radioButton.isSelected = true

                    // settings from commonInit/setupUI
                    expect(radioButton.isSelected) == true
                    expect(radioButton.bounds) == CGRect(origin: radioButton.bounds.origin,
                        size: CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2))
                    expect(radioButton.radioCircle.clipsToBounds) == true
                    expect(radioButton.indicatorView.clipsToBounds) == true
                    expect(radioButton.groupID) == 1
                    expect(radioButton.buttonID) == 2

                    expect(radioButton.buttonColor) == UIColor.red
                    expect(radioButton.highlightColor) == UIColor.blue
                    expect(radioButton.indicatorColor) == UIColor.green
                    expect(radioButton.borderColorNotSelected) == UIColor.purple
                    expect(radioButton.borderColorSelected) == UIColor.blue
                    expect(radioButton.radioCircle.layer.borderColor) == UIColor.blue.cgColor

                    expect(radioButton.borderWidth) == 4
                    expect(radioButton.buttonRadius) == 14
                    expect(radioButton.indicatorRadius) == 7
                    expect(radioButton.animationTime) == 0.1
                    expect(radioButton.indicatorView.alpha).toEventually(equal(1.0), timeout: 1)
                    expect(radioButton.radioCircle.layer.cornerRadius) == radioButton.radioCircle.frame.size.height / 2
                    expect(radioButton.indicatorView.layer.cornerRadius) == radioButton.indicatorView.frame.size.height / 2
                }

                it("should animate back and forth from selected") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)

                    radioButton.animationTime = 0.1
                    radioButton.isSelected = true
                    radioButton.isSelected = false
                    radioButton.isSelected = true

                    expect(radioButton.isSelected) == true
                    expect(radioButton.animationTime) == 0.1
                    expect(radioButton.indicatorView.alpha).toEventually(equal(1.0), timeout: 1)
                }
            }

            describe("button actions") {
                it("should deselect all radio buttons besides the button in the group that was selected") {
                    radioButton = WRadioButton()
                    radioButton.buttonID = 1
                    radioButton.groupID = 1

                    let radioButton2 = WRadioButton()
                    radioButton2.buttonID = 2
                    radioButton2.groupID = 1

                    let radioButton3 = WRadioButton()
                    radioButton3.buttonID = 3
                    radioButton3.groupID = 1

                    let radioButton4 = WRadioButton()
                    radioButton4.buttonID = 4
                    radioButton4.groupID = 1

                    // Not in group
                    let radioButton5 = WRadioButton()
                    radioButton5.buttonID = 5
                    radioButton5.groupID = 2

                    let radioButton6 = WRadioButton()
                    radioButton6.buttonID = 5
                    radioButton6.groupID = 3

                    // Selected actions
                    radioButton2.isSelected = true
                    radioButton4.isSelected = true
                    radioButton5.isSelected = true
                    radioButton6.isSelected = true

                    expect(radioButton.isSelected) == false
                    expect(radioButton2.isSelected) == false
                    expect(radioButton3.isSelected) == false
                    // Last button in group to be selected
                    expect(radioButton4.isSelected) == true
                    // Buttons in separate group should not be deselected
                    expect(radioButton5.isSelected) == true
                    expect(radioButton6.isSelected) == true
                }

                it("should handle button presses on touch began") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .began
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.highlightColor
                    expect(radioButton.isSelected) == false
                }

                it("should handle button presses on touch ended and set selected if currently highlighted") {
                    radioButton = WRadioButton()

                    let pressRecognizerStart = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizerStart.testState = .began
                    radioButton.buttonWasPressed(pressRecognizerStart)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.highlightColor

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .ended
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.buttonColor
                    expect(radioButton.isSelected) == true
                }

                it("should handle button presses on touch ended and not set selected if currently not highlighted") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .ended
                    radioButton.buttonWasPressed(pressRecognizer)

                    // Currently not highlighted so not within the threshold
                    expect(radioButton.radioCircle.backgroundColor) == radioButton.buttonColor
                    expect(radioButton.isSelected) == false
                }

                it("should handle button presses on touch changed when at or below threshold") {
                    radioButton = WRadioButton()
                    radioButton.center = CGPoint(x: radioButton.touchThreshold, y: 0)

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .changed
                    // LocationInView set to CGPointZero for mock
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.highlightColor
                    expect(radioButton.isSelected) == false
                }

                it("should handle button presses on touch changed when over threshold") {
                    radioButton = WRadioButton()
                    radioButton.center = CGPoint(x: radioButton.touchThreshold + 1, y: 0)

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .changed
                    // LocationInView set to CGPointZero for mock
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.buttonColor
                    expect(radioButton.isSelected) == false
                }
                
                it("should not handle button presses on touch when button is not enabled") {
                    radioButton = WRadioButton()
                    radioButton.isEnabled = false
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .began
                    radioButton.buttonWasPressed(pressRecognizer)
                    
                    // Should not highlight
                    expect(radioButton.radioCircle.backgroundColor) == radioButton.buttonColor
                    expect(radioButton.isSelected) == false
                }

                it("should handle button presses on other events") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .cancelled
                    radioButton.buttonWasPressed(pressRecognizer)
                }
            }
        }
    }
}
