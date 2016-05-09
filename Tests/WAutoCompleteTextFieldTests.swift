//
//  WAutoCompleteTextFieldTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WAutoCompleteTextFieldSpec: QuickSpec {
    override func spec() {
        describe("WAutoCompleteTextFieldSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var textView: WAutoCompleteTextView!
            
            beforeEach({
                subject = UIViewController()
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })
            
            describe("when app has been init") {
                it("should init with coder correctly") {
                    textView = WAutoCompleteTextView()
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WAutoCompleteTextView")
                    
                    NSKeyedArchiver.archiveRootObject(textView, toFile: locToSave)
                    
                    let object = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WAutoCompleteTextView
                    
                    expect(object).toNot(equal(nil))
                    
                    // default settings from commonInit
                    expect(textView.numCharactersBeforeAutoComplete) == 1
                    expect(textView.addSpaceAfterReplacement) == true
                    expect(textView.replacesControlPrefix) == false
                }
                
                it("should fit the superview it is added to") {
                    textView = WAutoCompleteTextView()
                    
                    subject.view.addSubview(textView)
                    
                    expect(textView.bounds.width).to(equal(subject.view.bounds.width))
                }
                
                it("should show auto complete table if prefix is typed with min num of following chars") {
                    textView = WAutoCompleteTextView()
                    textView.controlPrefix = "@"
                    
                    let textField = textView.textField
                    textField.text = "@test"
                    textField.select(self)
                    textView.textFieldDidChange(textField)
                    textView.reloadInputViews()

                    let range = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.beginningOfDocument)
                    textField.selectedTextRange = range
                    
                    textView.processWordAtCursor(textField)
                    
                    expect(textView.autoCompleteTable.hidden) == false
                }
            }
            
            describe("keyboard") {
                it("should receive notification when keyboard will show") {
                    textView = WAutoCompleteTextView()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object: nil)
                }
                
                it("should set view to bottom when keyboard will hide") {
                    textView = WAutoCompleteTextView()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
                    
                    expect(textView.frame.origin.y).toEventually(equal(0), timeout: 0.3)
                }
            }
            
            describe("auto complete") {
                it("should show table correctly") {
                    textView = WAutoCompleteTextView()
                    textView.showAutoCompleteView()
                    
                    expect(textView.autoCompleteTable.hidden) == false
                }
                
                it("should hide table correctly") {
                    textView = WAutoCompleteTextView()
                    textView.showAutoCompleteView(false)
                    
                    expect(textView.autoCompleteTable.hidden).toEventually(beTrue(), timeout: 0.3)
                }
            }
        }
    }
}