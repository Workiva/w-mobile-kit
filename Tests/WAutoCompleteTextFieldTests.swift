//
//  WAutoCompleteTextFieldTests.swift
//  WMobileKit
//
//  Code coverage at 81% due to issue with UITextField not getting a beginningOfDocument property
//  set when setting its text manually, and thus not being able to access a selectedTextRange
//

import Quick
import Nimble
@testable import WMobileKit

class WAutoCompleteTextFieldSpec: QuickSpec {
    override func spec() {
        describe("WAutoCompleteTextFieldSpec") {
            var subject: AutoCompleteTestViewController!
            var window: UIWindow!
            var textView: WAutoCompleteTextView!
            
            beforeEach({
                subject = AutoCompleteTestViewController()
                textView = WAutoCompleteTextView()
                textView.delegate = subject
                textView.dataSource = subject
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })
            
            afterEach({
                if textView != nil {
                    textView.removeFromSuperview()
                }
                textView = nil
            })
            
            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(textView.numCharactersBeforeAutoComplete) == 1
                    expect(textView.addSpaceAfterReplacement) == true
                    expect(textView.replacesControlPrefix) == false
                }

                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WAutoCompleteTextView")
                    
                    NSKeyedArchiver.archiveRootObject(textView, toFile: locToSave)
                    
                    let object = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WAutoCompleteTextView
                    
                    expect(object).toNot(equal(nil))
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
                
                it("should fit the superview it is added to") {
                    subject.view.addSubview(textView)
                    
                    expect(textView.bounds.width).to(equal(subject.view.bounds.width))
                }
                
                it("should have properties set properly") {
                    subject.view.addSubview(textView)
                    
                    textView.rowHeight = 50
                    textView.maxAutoCompleteHeight = 150
                    textView.showAutoCompleteView()
                    
                    expect(textView.autoCompleteTable.frame.size.height).toEventually(equal(100), timeout: 0.3)
                }
                
                it("should have properties set properly without delegate") {
                    textView = WAutoCompleteTextView()
                    
                    textView.rowHeight = 50
                    textView.maxAutoCompleteHeight = 150
                    textView.showAutoCompleteView()
                    
                    expect(textView.autoCompleteTable.frame.size.height).toEventually(equal(150), timeout: 0.3)
                }
            }
            
            describe("notifications") {
                it("should receive notification when keyboard will show") {
                    subject.view.addSubview(textView)
                    
                    let userInfo: [NSObject: AnyObject] = [UIKeyboardFrameEndUserInfoKey: NSValue(CGRect: CGRect(x: 0, y: 0, width: 10, height: 10))]
                    let notification = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo: userInfo)
                    
                    NSNotificationCenter.defaultCenter().postNotification(notification)
                }
                
                it("should set view to bottom when keyboard will hide") {
                    subject.view.addSubview(textView)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
                    
                    expect(textView.frame.origin.y).toEventually(equal(textView.superview!.frame.size.height - textView.frame.size.height), timeout: 0.3)
                }
                
                it("should remove as observer when deinit") {
                    textView = nil
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
                }
            }
            
            describe("auto complete") {
                it("should show table correctly") {
                    textView.showAutoCompleteView()
                    
                    expect(textView.autoCompleteTable.hidden) == false
                }
                
                it("should hide table correctly") {
                    textView.showAutoCompleteView(false)
                    
                    expect(textView.autoCompleteTable.hidden).toEventually(beTrue(), timeout: 0.3)
                }
                
                // Unable to test both processWordAtCursor and wordRangeAtCursor due to
                //   iOS bug not setting .beginningOfDocument when setting text manually on UITextField
                it("should show auto complete table if prefix is typed with min num of following chars") {
                    subject.view.addSubview(textView)
                    textView.controlPrefix = "@"
                    
                    let textField = textView.textField
                    textField.text = "@test"
                    
                    let range = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
                    textField.selectedTextRange = range
                    
                    textView.textFieldDidChange(textField)
                    
//                    expect(textView.autoCompleteTable.hidden) == false
                }
                
                it("should replace auto completions correctly") {
                    let initialText = "Unit testing @a"
                    let finalText = "Unit testing @auto completion "
                    textView.textField.text = initialText
                    let range = initialText.rangeOfString("@a")
                    textView.autoCompleteRange = range
                    
                    textView.acceptAutoCompletionWithString("auto completion")
                    
                    expect(textView.textField.text).to(equal(finalText))
                }
                
                it("should replace auto completions correctly in middle of string") {
                    textView.addSpaceAfterReplacement = false
                    let initialText = "Unit testing @a completion"
                    let finalText = "Unit testing @auto completion"
                    textView.textField.text = initialText
                    let range = initialText.rangeOfString("@a")
                    textView.autoCompleteRange = range
                    
                    textView.acceptAutoCompletionWithString("auto")
                    
                    expect(textView.textField.text).to(equal(finalText))
                }
                
                it("should replace auto completions correctly with overriding prefix") {
                    textView.addSpaceAfterReplacement = false
                    textView.replacesControlPrefix = true
                    let initialText = "Unit testing @a"
                    let finalText = "Unit testing auto completion"
                    textView.textField.text = initialText
                    let range = initialText.rangeOfString("@a")
                    textView.autoCompleteRange = range
                    
                    textView.acceptAutoCompletionWithString("auto completion")
                    
                    expect(textView.textField.text).to(equal(finalText))
                }
                
                it("should dismiss auto complete when table cell is selected") {
                    textView.autoCompleteTable.reloadData()
                    textView.tableView(textView.autoCompleteTable, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                    textView.showAutoCompleteView()
                    
                    expect(textView.autoCompleteTable.hidden).toEventually(equal(true), timeout: 0.3)
                }
                
                it("should dismiss auto complete when text field is done editing") {
                    textView.showAutoCompleteView()
                    textView.textFieldDidEndEditing(textView.textField)
                    
                    expect(textView.autoCompleteTable.hidden).toEventually(equal(true), timeout: 0.3)
                }
                
                it("should dismiss auto complete if auto complete is up and there is no selection") {
                    textView.showAutoCompleteView()
                    
                    textView.processWordAtCursor(textView.textField)
                    
                    expect(textView.autoCompleteTable.hidden).toEventually(beTrue(), timeout: 0.3)
                }
                
                it("should return nil for word range at cursor if text is empty") {
                    expect(textView.wordRangeAtCursor(textView.textField)).to(beNil())
                }
            }
        }
    }
}

class AutoCompleteTestViewController: UIViewController, WAutoCompleteTextViewDelegate, WAutoCompleteTextViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    func heightForAutoCompleteTable() -> CGFloat {
        return 100
    }
}