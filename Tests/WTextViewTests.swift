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
            
            // Markdown strings
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
                    expect(textView.leftPaddingForLeftImage) == 4
                    expect(textView.verticalOffsetForLeftImage) == 0
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
        
        describe("WTextViewSpec") {
            var textView: WTextView!
                        
            describe("when text view has been init") {
                let verifyCommonInit = {
                    expect(textView.editable).to(beFalse())
                    expect(textView.scrollEnabled).to(beFalse())
                }
                
                it("should init with coder correctly and verify commonInit") {
                    textView = WTextView()
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WTextView")
                    
                    NSKeyedArchiver.archiveRootObject(textView, toFile: locToSave)
                    
                    let textView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTextView
                    
                    expect(textView).toNot(equal(nil))
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
                
                describe("when text view properties change") {
                    it("should propogate the font to the placeholder") {
                        textView = WTextView()
                        textView.font = UIFont.systemFontOfSize(20)
                        
                        expect(textView.placeholderLabel.font) == textView.font
                    }
                    
                    it("should propogate the text alignment to the placeholder") {
                        textView = WTextView()
                        textView.textAlignment = .Center
                        
                        expect(textView.placeholderLabel.textAlignment) == textView.textAlignment
                    }
                    
                    it("should allow the placeholder text to be specified") {
                        textView = WTextView()
                        textView.placeholderText = "Something"
                        
                        expect(textView.placeholderLabel.text) == "Something"
                    }
                    
                    it("should allow the placeholder text color to be specified") {
                        textView = WTextView()
                        textView.placeholderTextColor = .redColor()
                        
                        expect(textView.placeholderLabel.textColor) == UIColor.redColor()                 
                    }
                    
                    it("should hide/show the placeholder label as expected") {
                        let parentView = UIView()
                        textView = WTextView()
                        parentView.addSubview(textView)
                        expect(textView.placeholderLabel.superview).toNot(beNil())
                        
                        textView.text = "Something"
                        expect(textView.placeholderLabel.hidden) == true
                        
                        textView.text = ""
                        expect(textView.placeholderLabel.hidden) == false
                    }
                    
                    it("should add a left image when specified") {
                        textView = WTextView()
                        expect(textView.leftImageView.superview).toNot(beNil())
                        expect(textView.leftImageView.image).to(beNil())
                        
                        let image = UIImage(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource("testImage1", ofType: "png")!)
                        textView.leftImage = image
                        
                        expect(textView.leftImageView.image).toNot(beNil())
                    }
                }
            }
        }        
    }
}