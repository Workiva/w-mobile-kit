//
//  WSwitchTests.swift
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

class WSwitchSpec: QuickSpec {
    override func spec() {
        describe("WSwitchSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var switchControl: WSwitch!
            
            beforeEach({
                subject = UIViewController()
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })
            
            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(switchControl.barView.alpha).to(beCloseTo(0.45, within: 0.1))
                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.frontCircle.hidden) == false
                    expect(switchControl.frontCircle.backgroundColor) == UIColor.whiteColor()
                }

                it("should init with coder correctly and verify commonInit") {
                    switchControl = WSwitch(true)
                    subject.view.addSubview(switchControl)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WSwitch")
                    
                    NSKeyedArchiver.archiveRootObject(switchControl, toFile: locToSave)
                    
                    let switchControl = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WSwitch
                    
                    expect(switchControl).toNot(equal(nil))
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
                
                it("should init and setup UI properly without initializer parameters") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    // verify UI is setup correctly
                    expect(switchControl.barView.alpha).to(beCloseTo(0.45, within: 0.1))
                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.frontCircle.hidden) == false
                    expect(switchControl.backCircle.frame.origin.x) == switchControl.barView.frame.origin.x + switchControl.barView.frame.size.width - switchControl.backCircle.frame.size.width
                }
                
                it("should init and setup UI properly with false initializer parameter") {
                    switchControl = WSwitch(false)
                    subject.view.addSubview(switchControl)
                    
                    // verify UI is setup correctly
                    expect(switchControl.barView.alpha).to(beCloseTo(0.45, within: 0.1))
                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.frontCircle.backgroundColor) == UIColor.whiteColor()
                    expect(switchControl.backCircle.frame.origin.x) == switchControl.barView.frame.origin.x
                }
                
                it("should setup UI properly with non default values") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    
                    switchControl.barWidth = 50
                    switchControl.barHeight = 10
                    switchControl.circleRadius = 15
                    
                    expect(switchControl.backCircle.frame.size.width) == 30
                    expect(switchControl.barView.frame.size.height) == 10
                    expect(switchControl.barView.frame.size.width) == 50
                    expect(switchControl.backCircle.frame.origin.x) == switchControl.barView.frame.origin.x + switchControl.barView.frame.size.width - switchControl.backCircle.frame.size.width
                }
                
                it("should have correct intrinsic size") {
                    switchControl = WSwitch()
                    
                    expect(switchControl.intrinsicContentSize()) == CGSize(width: switchControl.barWidth, height: switchControl.circleRadius * 2)
                }
                
                it("should not crash when trying to setup UI without having commonInit") {
                    switchControl = WSwitch()
                    switchControl.barView.removeFromSuperview()
                    switchControl.backCircle.removeFromSuperview()
                    switchControl.didCommonInit = false
                    switchControl.setupUI()
                    
                    expect(switchControl).toNot(beNil())
                }
            }
            
            describe("setting the on value") {
                it("should animate correctly from off to on") {
                    switchControl = WSwitch(false)
                    subject.view.addSubview(switchControl)
                    
                    expect(switchControl.backCircle.frame.origin.x) == switchControl.barView.frame.origin.x
                    
                    switchControl.setOn(true, animated: true)
                    
                    let barViewFrame = switchControl.barView.frame
                    expect(switchControl.backCircle.frame.origin.x).toEventually(equal(barViewFrame.origin.x + barViewFrame.size.width - switchControl.backCircle.frame.size.width), timeout: 0.3)
                }
                
                it("should animate correctly from on to off") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let barViewFrame = switchControl.barView.frame
                    expect(switchControl.backCircle.frame.origin.x) == barViewFrame.origin.x + barViewFrame.size.width - switchControl.backCircle.frame.size.width
                    
                    switchControl.setOn(false, animated: true)
                    
                    expect(switchControl.backCircle.frame.origin.x).toEventually(equal(switchControl.barView.frame.origin.x), timeout: 0.3)
                }
                
                it("should toggle from tap from starting off and not sliding") {
                    switchControl = WSwitch()
                    switchControl.on = false
                    switchControl.didSlideSwitch = false
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }

                it("should toggle from tap from starting on and not sliding") {
                    switchControl = WSwitch()
                    switchControl.on = true
                    switchControl.didSlideSwitch = false

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.on) == false
                }
                
                it("should switch value to false when sliding left") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == false
                }
                
                it("should switch value to true when sliding right") {
                    switchControl = WSwitch(false)
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    pressRecognizer.returnPoint = CGPoint(x: switchControl.frame.width, y: 0)
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }
                
                it("should not switch value on after press if switch has been slid") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    switchControl.on = false
                    switchControl.didSlideSwitch = true

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == false
                }

                it("should not switch value off after press if switch has been slid") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    switchControl.on = true
                    switchControl.didSlideSwitch = true

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.on) == true
                }
                
                it("should not switch value if switch is not enabled") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    switchControl.enabled = false
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }

                it("should handle button presses on touch began") {
                    switchControl = WSwitch()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Began
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 0.5
                }

                it("should handle button presses on touch changed when over threshold starting on") {
                    switchControl = WSwitch()
                    switchControl.on = true
                    switchControl.center = CGPointMake(switchControl.touchThreshold+1, 0)

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    // LocationInView set to CGPointZero for mock
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == true
                }

                it("should handle button presses on touch changed when over threshold starting off") {
                    switchControl = WSwitch()
                    switchControl.on = false
                    switchControl.center = CGPointMake(switchControl.touchThreshold+1, 0)

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    // LocationInView set to CGPointZero for mock
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == false
                }

                it("should handle cancelled and failed correctly to reset the switch to the correct state when on") {
                    switchControl = WSwitch()

                    // when switch is on
                    switchControl.on = true

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)

                    // Cancelled
                    pressRecognizer.testState = .Cancelled
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == true

                    // Finished
                    pressRecognizer.testState = .Failed
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == true
                }

                it("should handle cancelled and failed correctly to reset the switch to the correct state when off") {
                    switchControl = WSwitch()

                    // when switch is off
                    switchControl.on = false

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)

                    // Cancelled
                    pressRecognizer.testState = .Cancelled
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == false

                    // Finished
                    pressRecognizer.testState = .Failed
                    switchControl.switchWasPressed(pressRecognizer)

                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.didSlideSwitch) == false
                    expect(switchControl.on) == false
                }
                
                it("should not react to press if not expected state") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerMock(target: switchControl, action: nil)
                    pressRecognizer.testState = .Possible
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }
            }
        }
    }
}
