//
//  WSwitchTests.swift
//  WMobileKit

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
                it("should init with coder correctly and verify commonInit") {
                    switchControl = WSwitch(true)
                    subject.view.addSubview(switchControl)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WSwitch")
                    
                    NSKeyedArchiver.archiveRootObject(switchControl, toFile: locToSave)
                    
                    let switchControl = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WSwitch
                    
                    expect(switchControl).toNot(equal(nil))
                    
                    // default settings from commonInit
                    expect(switchControl.barView.alpha) == 0.45
                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.frontCircle.hidden) == true
                }
                
                it("should init properly without initializer parameters") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    // default settings from commonInit
                    expect(switchControl.barView.alpha) == 0.45
                    expect(switchControl.frontCircle.alpha) == 1.0
                    expect(switchControl.frontCircle.hidden) == false
                    expect(switchControl.backCircle.frame.origin.x) == switchControl.barView.frame.origin.x + switchControl.barView.frame.size.width - switchControl.backCircle.frame.size.width
                }
                
                it("should init properly with false initializer parameter") {
                    switchControl = WSwitch(false)
                    subject.view.addSubview(switchControl)
                    
                    // default settings from commonInit
                    expect(switchControl.barView.alpha) == 0.45
                    expect(switchControl.frontCircle.alpha) == 0.0
                    expect(switchControl.frontCircle.hidden) == true
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
                
                it("should not crash when trying to setup UI without barView subview") {
                    switchControl = WSwitch()
                    switchControl.barView.removeFromSuperview()
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
                
                it("should toggle from tap") {
                    switchControl = WSwitch()
                    
                    let pressRecognizer = UILongPressGestureRecognizerTest(target: switchControl, action: nil)
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == false
                }
                
                it("should switch value to false when sliding left") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerTest(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == false
                }
                
                it("should switch value to true when sliding right") {
                    switchControl = WSwitch(false)
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerTest(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    pressRecognizer.slideLeft = false
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }
                
                it("should not switch value after press if switch has been slid") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerTest(target: switchControl, action: nil)
                    pressRecognizer.testState = .Changed
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    pressRecognizer.testState = .Ended
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == false
                }
                
                it("should not react to press if not expected state") {
                    switchControl = WSwitch()
                    subject.view.addSubview(switchControl)
                    switchControl.setupUI()
                    
                    let pressRecognizer = UILongPressGestureRecognizerTest(target: switchControl, action: nil)
                    pressRecognizer.testState = .Cancelled
                    switchControl.switchWasPressed(pressRecognizer)
                    
                    expect(switchControl.on) == true
                }
            }
        }
    }
}

public class UILongPressGestureRecognizerTest : UILongPressGestureRecognizer {
    public var testState: UIGestureRecognizerState!
    public var slideLeft: Bool = true
    
    public override var state: UIGestureRecognizerState {
        return testState
    }
    
    public override func locationInView(view: UIView?) -> CGPoint {
        if (view != nil && !slideLeft) {
            return CGPoint(x: view!.frame.origin.x + view!.frame.size.width, y: view!.frame.origin.y)
        }
        
        return CGPointZero
    }
}