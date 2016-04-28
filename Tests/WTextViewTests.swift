//
//  WTextViewTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit


class WTextViewTests: QuickSpec {
    override func spec() {
        describe("WTextViewSpec") {
            var textView: WTextView!
            
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

            
            beforeEach({

            })
            
            describe("when text view has been init") {
                it("should parse single markdown URL correctly") {
                    textView = WTextView(string1)
                    expect(textView.attributedText.string).to(equal(parsedString1))
                }
                
                it("should parse multiple markdown URLs correctly") {
                    textView = WTextView(string2)
                    expect(textView.attributedText.string).to(equal(parsedString2))
                }
                
                it("should parse complex markdown URLs correctly") {
                    textView = WTextView(string3)
                    expect(textView.attributedText.string).to(equal(parsedString3))
                }
                
                it("should not parse incorrect markdown URLs") {
                    textView = WTextView(string4)
                    expect(textView.attributedText.string).to(equal(string4))
                }
                
                it("should not parse anything if no markdown exists") {
                    textView = WTextView(string5)
                    expect(textView.attributedText.string).to(equal(string5))
                }
                
                it("should parse only correct markdown URLs") {
                    textView = WTextView(string6)
                    expect(textView.attributedText.string).to(equal(parsedString6))
                }
                
                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("testsTextView")
                    
                    textView = WTextView()
                    
                    NSKeyedArchiver.archiveRootObject(textView, toFile: locToSave)
                    
                    let textView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTextView
                    
                    expect(textView).toNot(equal(nil))
                    expect(textView.editable).to(beFalse())
                    expect(textView.scrollEnabled).to(beFalse())
                }
            }
            
            describe("when text changes") {
                it("should parse correctly when setting the text after initialization") {
                    textView = WTextView()
                    textView.text = string1
                    expect(textView.attributedText.string).to(equal(parsedString1))
                }
            }
        }
    }
}