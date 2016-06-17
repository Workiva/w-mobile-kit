//
//  WTextFieldTests.swift
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

class WTextFieldTests: QuickSpec {
    override func spec() {
        describe("WTextFieldSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var textField: WTextField!

            beforeEach({
                subject = UIViewController()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })

            afterEach({
                textField = nil
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(textField.imageSquareSize) == 16
                    expect(textField.paddingBetweenTextAndImage) == 8
                    expect(textField.bottomLineWidth) == 1
                    expect(textField.bottomLineWidthWithText) == 2
                    expect(textField.leftImage).to(beNil())
                    expect(textField.leftView).to(beNil())
                    expect(textField.rightImage).to(beNil())
                    expect(textField.rightView).to(beNil())
                    expect(textField.bottomLineColor).to(equal(UIColor.whiteColor()))
                }

                it("should init with coder correctly and verify commonInit") {
                    textField = WTextField()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WTextField")

                    NSKeyedArchiver.archiveRootObject(textField, toFile: locToSave)

                    let object = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTextField

                    expect(object).toNot(equal(nil))

                    // default settings from commonInit
                    verifyCommonInit()
                }

                it("should successfully add and display a text field with default settings") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }

                    subject.view.layoutIfNeeded()

                    // public properties
                    verifyCommonInit()
                    expect(textField.placeHolderTextColor) == UIColor(hex: 0xFFFFFF, alpha: 0.55)

                    // rect sizing
                    let textRect = textField.textRectForBounds(textField.bounds)
                    expect(textRect.origin.x) == 0
                    expect(textRect.origin.y) == 0
                    expect(textRect.width) == 160
                    expect(textRect.height) == 30

                    let placeHolderRect = textField.placeholderRectForBounds(textField.bounds)
                    expect(placeHolderRect.origin.x) == 0
                    expect(placeHolderRect.origin.y) == 0
                    expect(placeHolderRect.width) == 160
                    expect(placeHolderRect.height) == 30

                    let editingRect = textField.editingRectForBounds(textField.bounds)
                    expect(editingRect.origin.x) == 0
                    expect(editingRect.origin.y) == 0
                    expect(editingRect.width) == 160
                    expect(editingRect.height) == 30

                    let leftViewRect = textField.leftViewRectForBounds(textField.bounds)
                    expect(leftViewRect.origin.x) == 0 // (textField.height - imageSquareSize) / 2 = (30 - 16) / 2
                    expect(leftViewRect.origin.y) == 7
                    expect(leftViewRect.width) == 16
                    expect(leftViewRect.height) == 16

                    let rightViewRect = textField.rightViewRectForBounds(textField.bounds)
                    expect(rightViewRect.origin.x) == 144 // textField.width - imageSquareSize
                    expect(rightViewRect.origin.y) == 7
                    expect(rightViewRect.width) == 16
                    expect(rightViewRect.height) == 16
                }

                it("should successfully add and display a text field with custom configurations") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }
                    textField.imageSquareSize = 20
                    textField.paddingBetweenTextAndImage = 10
                    textField.bottomLineWidth = 2
                    textField.bottomLineWidthWithText = 3
                    textField.bottomLineColor = .blueColor()

                    // Placeholder text should be nil, then when color is set, should be ""
                    expect(textField.placeholder).to(beNil())
                    textField.placeHolderTextColor = .blueColor()
                    textField.placeholder = "placeholder"
                    expect(textField.placeholder) == "placeholder"

                    subject.view.layoutIfNeeded()

                    // public properties
                    expect(textField.imageSquareSize) == 20
                    expect(textField.paddingBetweenTextAndImage) == 10
                    expect(textField.bottomLineWidth) == 2
                    expect(textField.bottomLineWidthWithText) == 3
                    expect(textField.bottomLineColor) == UIColor.blueColor()

                    // rect sizing
                    let leftViewRect = textField.leftViewRectForBounds(textField.bounds)
                    expect(leftViewRect.width) == 20
                    expect(leftViewRect.height) == 20

                    let rightViewRect = textField.rightViewRectForBounds(textField.bounds)
                    expect(rightViewRect.origin.x) == 140 // textField.width - imageSquareSize
                    expect(rightViewRect.origin.y) == 5
                    expect(rightViewRect.width) == 20
                    expect(rightViewRect.height) == 20
                }

                it("should successfully add and display a text field with a left icon") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }

                    // left image, with default 16x16 and 8 padding, 24 taken off of widths
                    textField.leftImage = UIImage()

                    subject.view.layoutIfNeeded()

                    // rect sizing
                    let textRect = textField.textRectForBounds(textField.bounds)
                    expect(textRect.origin.x) == 24
                    expect(textRect.width) == 136
                    expect(textRect.height) == 30

                    let placeHolderRect = textField.placeholderRectForBounds(textField.bounds)
                    expect(placeHolderRect.origin.x) == 24
                    expect(placeHolderRect.width) == 136
                    expect(placeHolderRect.height) == 30

                    let editingRect = textField.editingRectForBounds(textField.bounds)
                    expect(editingRect.origin.x) == 24
                    expect(editingRect.width) == 136
                    expect(editingRect.height) == 30
                }

                it("should successfully add and display a text field with a right icon") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }

                    // left image, with default 16x16 and 8 padding, 24 taken off of widths
                    textField.rightImage = UIImage()

                    subject.view.layoutIfNeeded()

                    // rect sizing
                    let textRect = textField.textRectForBounds(textField.bounds)
                    expect(textRect.origin.x) == 0
                    expect(textRect.width) == 136
                    expect(textRect.height) == 30

                    let placeHolderRect = textField.placeholderRectForBounds(textField.bounds)
                    expect(placeHolderRect.origin.x) == 0
                    expect(placeHolderRect.width) == 136
                    expect(placeHolderRect.height) == 30

                    let editingRect = textField.editingRectForBounds(textField.bounds)
                    expect(editingRect.origin.x) == 0
                    expect(editingRect.width) == 136
                    expect(editingRect.height) == 30
                }

                it("should successfully add and display a text field with both icons set") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }

                    // left image, with default 16x16 and 8 padding, 24 taken off of widths
                    textField.leftImage = UIImage()
                    textField.rightImage = UIImage()

                    subject.view.layoutIfNeeded()

                    // rect sizing
                    let textRect = textField.textRectForBounds(textField.bounds)
                    expect(textRect.origin.x) == 24
                    expect(textRect.width) == 112
                    expect(textRect.height) == 30
                    
                    let placeHolderRect = textField.placeholderRectForBounds(textField.bounds)
                    expect(placeHolderRect.origin.x) == 24
                    expect(placeHolderRect.width) == 112
                    expect(placeHolderRect.height) == 30
                    
                    let editingRect = textField.editingRectForBounds(textField.bounds)
                    expect(editingRect.origin.x) == 24
                    expect(editingRect.width) == 112
                    expect(editingRect.height) == 30
                }

                it("should update bottom border with text change") {
                    textField = WTextField()

                    subject.view.addSubview(textField)
                    textField.snp_makeConstraints { (make) in
                        make.centerX.equalTo(subject.view)
                        make.top.equalTo(subject.view).offset(10)
                        make.width.equalTo(160)
                        make.height.equalTo(30)
                    }

                    subject.view.layoutIfNeeded()
                    
                    expect(textField.bottomLineWidth) == 1
                    expect(textField.bottomLineWidthWithText) == 2
                }
            }
        }
    }
}