//
//  WRadioButtonTests.swift
//  WMobileKit

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
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                radioButton = nil
            })
            
            describe("when app has been init") {
                it("should init with coder correctly and verify commonInit") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WRadioButton")
                    
                    NSKeyedArchiver.archiveRootObject(radioButton, toFile: locToSave)
                    
                    let radioButton = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WRadioButton
                    
                    expect(radioButton).toNot(equal(nil))
                    
                    // default settings from commonInit and default var values
                    expect(radioButton.selected) == false
                    expect(radioButton.bounds) == CGRect(origin: radioButton.bounds.origin,
                                                         size: CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2))
                    expect(radioButton.radioCircle.clipsToBounds) == true
                    expect(radioButton.indicatorView.clipsToBounds) == true
                    expect(radioButton.groupID) == 0
                    expect(radioButton.buttonID) == 0
                    expect(radioButton.buttonColor) == UIColor.whiteColor()
                    expect(radioButton.highlightColor) == UIColor.grayColor()
                    expect(radioButton.indicatorColor) == UIColor.darkGrayColor()
                    expect(radioButton.borderColor) == UIColor.lightGrayColor()
                    expect(radioButton.borderWidth) == 2.0
                    expect(radioButton.buttonRadius) == 12.0
                    expect(radioButton.indicatorRadius) == 6
                    expect(radioButton.animationTime) == 0.2
                    expect(radioButton.indicatorView.alpha) == 0.0
                    expect(radioButton.radioCircle.layer.cornerRadius) == radioButton.radioCircle.frame.size.height / 2
                    expect(radioButton.indicatorView.layer.cornerRadius) == radioButton.indicatorView.frame.size.height / 2
                }
                
                it("should init and setupUI properly without initializer parameters") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)
                    radioButton.setupUI()
                    
                    // default settings from commonInit/setupUI
                    expect(radioButton.selected) == false
                    expect(radioButton.bounds) == CGRect(origin: radioButton.bounds.origin,
                                                         size: CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2))
                    expect(radioButton.radioCircle.clipsToBounds) == true
                    expect(radioButton.indicatorView.clipsToBounds) == true
                    expect(radioButton.groupID) == 0
                    expect(radioButton.buttonID) == 0
                    expect(radioButton.buttonColor) == UIColor.whiteColor()
                    expect(radioButton.highlightColor) == UIColor.grayColor()
                    expect(radioButton.indicatorColor) == UIColor.darkGrayColor()
                    expect(radioButton.borderColor) == UIColor.lightGrayColor()
                    expect(radioButton.borderWidth) == 2.0
                    expect(radioButton.buttonRadius) == 12.0
                    expect(radioButton.indicatorRadius) == 6
                    expect(radioButton.animationTime) == 0.2
                    expect(radioButton.indicatorView.alpha) == 0.0
                    expect(radioButton.radioCircle.layer.cornerRadius) == radioButton.radioCircle.frame.size.height / 2
                    expect(radioButton.indicatorView.layer.cornerRadius) == radioButton.indicatorView.frame.size.height / 2
                }
                
                it("should init properly with true initializer parameter") {
                    radioButton = WRadioButton(true)
                    subject.view.addSubview(radioButton)
                    radioButton.setupUI()
                    
                    // true init changes
                    expect(radioButton.selected) == true
                    expect(radioButton.indicatorView.alpha) == 1.0
                }

                it("should have correct intrinsic size") {
                    radioButton = WRadioButton()
                    
                    expect(radioButton.intrinsicContentSize()) == CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2)
                }
            }
            
            describe("setting custom values for vars") {
                it("should reflect changed vars properly") {
                    radioButton = WRadioButton()
                    subject.view.addSubview(radioButton)

                    radioButton.groupID = 1
                    radioButton.buttonID = 2
                    radioButton.buttonColor = UIColor.redColor()
                    radioButton.highlightColor = UIColor.blueColor()
                    radioButton.indicatorColor = UIColor.greenColor()
                    radioButton.borderColor = UIColor.purpleColor()
                    radioButton.borderWidth = 4
                    radioButton.buttonRadius = 14
                    radioButton.indicatorRadius = 7
                    radioButton.borderWidth = 4
                    radioButton.animationTime = 0.1
                    radioButton.selected = true

                    // default settings from commonInit/setupUI
                    expect(radioButton.selected) == true
                    expect(radioButton.bounds) == CGRect(origin: radioButton.bounds.origin,
                                                         size: CGSize(width: radioButton.buttonRadius * 2, height: radioButton.buttonRadius * 2))
                    expect(radioButton.radioCircle.clipsToBounds) == true
                    expect(radioButton.indicatorView.clipsToBounds) == true
                    expect(radioButton.groupID) == 1
                    expect(radioButton.buttonID) == 2
                    expect(radioButton.buttonColor) == UIColor.redColor()
                    expect(radioButton.highlightColor) == UIColor.blueColor()
                    expect(radioButton.indicatorColor) == UIColor.greenColor()
                    expect(radioButton.borderColor) == UIColor.purpleColor()
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
                    radioButton.selected = true
                    radioButton.selected = false
                    radioButton.selected = true

                    expect(radioButton.selected) == true
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
                    radioButton2.selected = true
                    radioButton4.selected = true
                    radioButton5.selected = true
                    radioButton6.selected = true

                    expect(radioButton.selected) == false
                    expect(radioButton2.selected) == false
                    expect(radioButton3.selected) == false
                    // Last button in group to be selected
                    expect(radioButton4.selected) == true
                    // Buttons in separate group should not be deselected
                    expect(radioButton5.selected) == true
                    expect(radioButton6.selected) == true
                }

                it("should handle button presses on touch began") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .Began
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.highlightColor
                    expect(radioButton.selected) == false
                }

                it("should handle button presses on touch ended") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .Ended
                    radioButton.buttonWasPressed(pressRecognizer)

                    expect(radioButton.radioCircle.backgroundColor) == radioButton.buttonColor
                    expect(radioButton.selected) == true
                }

                it("should handle button presses on other events") {
                    radioButton = WRadioButton()

                    let pressRecognizer = UILongPressGestureRecognizerMock(target: radioButton, action: nil)
                    pressRecognizer.testState = .Cancelled
                    radioButton.buttonWasPressed(pressRecognizer)
                }
            }
        }
    }
}
