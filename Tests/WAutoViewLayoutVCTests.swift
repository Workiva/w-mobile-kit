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

class WAutoViewLayoutVCSpec: QuickSpec {
    override func spec() {
        describe("WAutoViewLayoutVCSpec") {
            var subject: WAutoViewLayoutVC!
            var window: UIWindow!
            var viewController: UIViewController!

            beforeEach({
                viewController = UIViewController()
                subject = WAutoViewLayoutVC()
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = viewController

                viewController.addViewControllerToContainer(viewController.view, viewController: subject)
                
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(subject.collectionView.scrollEnabled) == false
                    expect(subject.leftSpacing) == 5
                    expect(subject.rightSpacing) == 5
                    expect(subject.topSpacing) == 5
                    expect(subject.bottomSpacing) == 5
                    expect(subject.views.count) == 0
                    expect(subject.collectionView.backgroundColor) == UIColor.clearColor()
                }

                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WAutoViewLayoutVC")
                    
                    NSKeyedArchiver.archiveRootObject(subject, toFile: locToSave)
                    
                    let object = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WAutoViewLayoutVC
                    
                    expect(object).toNot(equal(nil))
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
            }

            describe("interactions") {
                it("should reload when new views are set") {
                    subject.views = WUtils.generateExampleViews(10)

                    expect(subject.views.count) == 10
                    expect(subject.fittedHeight) == subject.collectionView.collectionViewLayout.collectionViewContentSize().height
                }

                it("should update when new properties are set") {
                    subject.leftSpacing = 10
                    subject.rightSpacing = 11
                    subject.topSpacing = 12
                    subject.bottomSpacing = 13

                    expect(subject.leftSpacing) == 10
                    expect(subject.rightSpacing) == 11
                    expect(subject.topSpacing) == 12
                    expect(subject.bottomSpacing) == 13
                }

                it("should return cell for views") {
                    subject.views = WUtils.generateExampleViews(10)

                    expect(subject.collectionView(subject.collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).toNot(equal(nil))
                }
            }
        }
    }
}
