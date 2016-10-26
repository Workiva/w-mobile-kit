//
//  WAutoCompleteTextViewTests.swift
//  WMobileKit
//
//  Code coverage at 81% due to issue with UITextView not getting a beginningOfDocument property
//  set when setting its text manually, and thus not being able to access a selectedTextRange
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

class WAutoCompleteTextViewSpec: QuickSpec {
    override func spec() {
        describe("WAutoCompleteTextViewSpec") {
            var subject: AutoCompleteTestViewController!
            var window: UIWindow!
            var autoCompleteView: WAutoCompleteTextView!
            
            beforeEach({
                subject = AutoCompleteTestViewController()
                autoCompleteView = WAutoCompleteTextView()
                autoCompleteView.delegate = subject
                autoCompleteView.dataSource = subject
                
                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })
            
            afterEach({
                if autoCompleteView != nil {
                    autoCompleteView.removeFromSuperview()
                }
                autoCompleteView = nil
            })
            
            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(autoCompleteView.numCharactersBeforeAutoComplete) == 1
                    expect(autoCompleteView.addSpaceAfterReplacement) == true
                    expect(autoCompleteView.replacesControlPrefix) == false
                }

                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WAutoCompleteTextView")
                    
                    NSKeyedArchiver.archiveRootObject(autoCompleteView, toFile: locToSave)
                    
                    let object = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WAutoCompleteTextView
                    
                    expect(object).toNot(equal(nil))
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
                
                it("should fit the superview it is added to") {
                    subject.view.addSubview(autoCompleteView)
                    subject.view.layoutIfNeeded()
                    
                    expect(autoCompleteView.bounds.width).to(equal(subject.view.bounds.width))
                }
                
                it("should have properties set properly") {
                    subject.view.addSubview(autoCompleteView)
                    
                    autoCompleteView.rowHeight = 50
                    autoCompleteView.maxAutoCompleteHeight = 150
                    autoCompleteView.showAutoCompleteTable()
                    
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(true), timeout: 0.5)
                }
                
                it("should have properties set properly without delegate") {
                    autoCompleteView = WAutoCompleteTextView()
                    
                    autoCompleteView.rowHeight = 50
                    autoCompleteView.maxAutoCompleteHeight = 150
                    autoCompleteView.showAutoCompleteTable()
                    
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(true), timeout: 0.5)
                }
            }
            
            describe("notifications") {
                it("should receive notification when keyboard will show") {
                    subject.view.addSubview(autoCompleteView)
                    
                    let userInfo: [AnyHashable: Any] = [UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 10, height: 10))]
                    let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo: userInfo)
                    
                    NotificationCenter.default.post(notification as Notification)
                }
                
                it("should set view to bottom when keyboard will hide") {
                    subject.view.addSubview(autoCompleteView)
                    
                    NotificationCenter.default.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                    
                    expect(autoCompleteView.frame.origin.y).toEventually(beCloseTo(autoCompleteView.superview!.frame.size.height - autoCompleteView.frame.size.height, within: 0.1), timeout: 0.3)
                }
                
                it("should remove as observer when deinit") {
                    autoCompleteView = nil
                    
                    NotificationCenter.default.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                }
            }
            
            describe("auto complete") {
                it("should show table correctly") {
                    expect(autoCompleteView.isShowingAutoComplete()) == false
                    autoCompleteView.showAutoCompleteTable()
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(true), timeout: 0.3)
                }
                
                it("should hide table correctly") {
                    expect(autoCompleteView.isShowingAutoComplete()) == false
                    autoCompleteView.showAutoCompleteTable()
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(true), timeout: 0.3)
                    autoCompleteView.showAutoCompleteTable(false)
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(false), timeout: 0.3)
                }
                
                // Unable to test both processWordAtCursor and wordRangeAtCursor due to
                //   iOS bug not setting .beginningOfDocument when setting text manually on UITextView
                it("should show auto complete table if prefix is typed with min num of following chars") {
                    subject.view.addSubview(autoCompleteView)
                    autoCompleteView.controlPrefix = "@"
                    
                    let textView = autoCompleteView.textView
                    textView.text = "@test"


                    let range = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
                    textView.selectedTextRange = range
                    
                    autoCompleteView.textViewDidChange(textView)
                    //expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(true), timeout: 0.3)
                }
                
                it("should replace auto completions correctly") {
                    let initialText = "Unit testing @a"
                    let finalText = "Unit testing @auto completion "

                    autoCompleteView.controlPrefix = "@"
                    autoCompleteView.textView.text = initialText
                    autoCompleteView.processWordAtCursor(autoCompleteView.textView)

                    autoCompleteView.acceptAutoCompletionWithString("auto completion")
                    
                    expect(autoCompleteView.textView.text).to(equal(finalText))
                }
                
                it("should replace auto completions correctly in middle of string") {
                    autoCompleteView.replacesControlPrefix = true
                    autoCompleteView.addSpaceAfterReplacement = false
                    let initialText = "Unit testing @a completion"
                    let finalText = "Unit testing auto completion"
                    autoCompleteView.textView.text = initialText
                    let range = initialText.range(of: "@a")
                    autoCompleteView.autoCompleteRange = range
                    
                    autoCompleteView.acceptAutoCompletionWithString("auto")
                    
                    expect(autoCompleteView.textView.text).to(equal(finalText))
                }
                
                it("should replace auto completions correctly with overriding prefix") {
                    autoCompleteView.addSpaceAfterReplacement = false
                    autoCompleteView.replacesControlPrefix = true
                    let initialText = "Unit testing @a"
                    let finalText = "Unit testing auto completion"
                    autoCompleteView.textView.text = initialText
                    let range = initialText.range(of: "@a")
                    autoCompleteView.autoCompleteRange = range
                    
                    autoCompleteView.acceptAutoCompletionWithString("auto completion")
                    
                    expect(autoCompleteView.textView.text).to(equal(finalText))
                }
                
                it("should dismiss auto complete when table cell is selected") {
                    autoCompleteView.autoCompleteTable.reloadData()
                    autoCompleteView.showAutoCompleteTable()
                    autoCompleteView.tableView(autoCompleteView.autoCompleteTable, didSelectRowAt: IndexPath(row: 0, section: 0))
                    
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(false), timeout: 0.3)
                }
                
                it("should dismiss auto complete when text view is done editing") {
                    autoCompleteView.showAutoCompleteTable()
                    autoCompleteView.textViewDidEndEditing(autoCompleteView.textView)
                    
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(false), timeout: 0.3)
                }
                
                it("should dismiss auto complete if auto complete is up and there is no selection") {
                    autoCompleteView.showAutoCompleteTable()
                    
                    autoCompleteView.processWordAtCursor(autoCompleteView.textView)
                    
                    expect(autoCompleteView.isShowingAutoComplete()).toEventually(equal(false), timeout: 0.3)
                }
                
                it("should return nil for word range at cursor if text is empty") {
                    expect(autoCompleteView.wordRangeAtCursor(autoCompleteView.textView)).to(beNil())
                }
            }
        }
    }
}

class AutoCompleteTestViewController: UIViewController, WAutoCompletionTextViewDelegate, WAutoCompleteTextViewDataSource, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    func heightForAutoCompleteTable(_ textView: WAutoCompleteTextView) -> CGFloat {
        return 100
    }
}
