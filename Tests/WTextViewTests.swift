//
//  WTextViewTests.swift
//  WMobileKit
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

class WTextViewTests: QuickSpec {
    override func spec() {
        describe("WMarkdownTextViewSpec") {
            var textView: WMarkdownTextView!
            
            // Usernames
            let string1 = "This has one [Markdown](URL) in it"
            let parsedString1 = "This has one Markdown in it"
            let string2 = "This has [two](URL) separate [links]()"
            let parsedString2 = "This has two separate links"
            let string3 = "This has complex [mar[kd]own]    (URL) in it"
            let parsedString3 = "This has complex mar[kd]own in it"
            let string4 = "This has [multiple])) incorrect [mark]]d(own) [URLs](() in [it][)"
            let string5 = "This has no markdown in it"
            let string6 = "This has one [inco]rre(ct) URL with [one correct](URL) URL"
            let parsedString6 = "This has one [inco]rre(ct) URL with one correct URL"
            
            describe("when text view has been init") {
                let verifyCommonInit = {
                    expect(textView.editable).to(beFalse())
                    expect(textView.scrollEnabled).to(beFalse())
                }

                it("should init with coder correctly and verify commonInit") {
                    textView = WMarkdownTextView()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WMarkdownTextView")

                    NSKeyedArchiver.archiveRootObject(textView, toFile: locToSave)

                    let textView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WMarkdownTextView

                    expect(textView).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should parse single markdown URL correctly") {
                    textView = WMarkdownTextView(string1)
                    expect(textView.attributedText.string).to(equal(parsedString1))
                }
                
                it("should parse multiple markdown URLs correctly") {
                    textView = WMarkdownTextView(string2)
                    expect(textView.attributedText.string).to(equal(parsedString2))
                }
                
                it("should parse complex markdown URLs correctly") {
                    textView = WMarkdownTextView(string3)
                    expect(textView.attributedText.string).to(equal(parsedString3))
                }
                
                it("should not parse incorrect markdown URLs") {
                    textView = WMarkdownTextView(string4)
                    expect(textView.attributedText.string).to(equal(string4))
                }
                
                it("should not parse anything if no markdown exists") {
                    textView = WMarkdownTextView(string5)
                    expect(textView.attributedText.string).to(equal(string5))
                }
                
                it("should parse only correct markdown URLs") {
                    textView = WMarkdownTextView(string6)
                    expect(textView.attributedText.string).to(equal(parsedString6))
                }
            }
            
            describe("when text changes") {
                it("should parse correctly when setting the text after initialization") {
                    textView = WMarkdownTextView()
                    textView.text = string1
                    expect(textView.attributedText.string).to(equal(parsedString1))
                }
            }
        }
    }
}