//
//  WAutoViewLayoutVCTests.swift
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
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
                
                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = viewController

                viewController.addViewControllerToContainer(viewController.view, viewController: subject)
                
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            })

            describe("when app has been init") {
                let verifyCommonInit = {
                    expect(subject.collectionView.isScrollEnabled) == false
                    expect(subject.leftSpacing) == 5
                    expect(subject.rightSpacing) == 5
                    expect(subject.topSpacing) == 5
                    expect(subject.bottomSpacing) == 5
                    expect(subject.views.count) == 0
                    expect(subject.collectionView.backgroundColor) == UIColor.clear
                    expect(subject.alignment) == xAlignment.center
                }

                it("should init with coder correctly") {
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WAutoViewLayoutVC")
                    
                    NSKeyedArchiver.archiveRootObject(subject, toFile: locToSave)
                    
                    let object = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WAutoViewLayoutVC
                    
                    expect(object).toNot(beNil())
                    
                    // default settings from commonInit
                    verifyCommonInit()
                }
            }

            describe("interactions") {
                it("should reload when new views are set") {
                    subject.views = WUtils.generateExampleViews(count: 10)

                    expect(subject.views.count) == 10
                    expect(subject.fittedHeight) == subject.collectionView.collectionViewLayout.collectionViewContentSize.height
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
                    subject.views = WUtils.generateExampleViews(count: 10)

                    expect(subject.collectionView(subject.collectionView, cellForItemAt: IndexPath(item: 0, section: 0))).toNot(beNil())
                }

                it("should be able to change alignment") {
                    expect(subject.alignment) == xAlignment.center
                    expect(subject.flowLayout is WLeftAlignedCollectionViewFlowLayout) == false

                    subject.alignment = xAlignment.left
                    expect(subject.alignment) == xAlignment.left
                    expect(subject.flowLayout is WLeftAlignedCollectionViewFlowLayout) == true

                    // Cannot yet align right
                    subject.alignment = xAlignment.right
                    expect(subject.alignment) == xAlignment.center
                    expect(subject.flowLayout is WLeftAlignedCollectionViewFlowLayout) == false
                }
            }

            describe("estimating height") {
                it("should estimate the correct height for the given views and spacing") {
                    let sampleViews = WUtils.generateExampleViews(count: 30)

                    subject.views = sampleViews

                    let estimatedHeight = WAutoViewLayoutVC.estimatedFittedHeight(views: sampleViews, constrainedWidth: viewController.view.frame.size.width)
                    let actualHeight = subject.fittedHeight

                    expect(estimatedHeight) == actualHeight
                }

                it("should estimate the correct height for the given views and spacing") {
                    let sampleViews = WUtils.generateExampleViews(count: 30)
                    let spacing: CGFloat = 8

                    subject.views = sampleViews
                    subject.rightSpacing = spacing
                    subject.leftSpacing = spacing
                    subject.topSpacing = spacing
                    subject.bottomSpacing = spacing

                    let estimatedHeight = WAutoViewLayoutVC.estimatedFittedHeight(views: sampleViews, constrainedWidth: viewController.view.frame.size.width, leftSpacing: spacing, topSpacing: spacing, rightSpacing: spacing, bottomSpacing: spacing)
                    let actualHeight = subject.fittedHeight

                    expect(estimatedHeight) == actualHeight
                }
            }

            describe("WLeftAlignedCollectionViewFlowLayout") {
                it("should layout elements to the left") {
                    let sampleViews = WUtils.generateExampleViews(count: 30)

                    subject.views = sampleViews
                    subject.alignment = .left

                    expect(subject.collectionView.collectionViewLayout is WLeftAlignedCollectionViewFlowLayout) == true

                    subject.collectionView.collectionViewLayout.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: 100, height: 100))
                }

                it("should not be set when layout is set to center") {
                    let sampleViews = WUtils.generateExampleViews(count: 30)

                    subject.views = sampleViews
                    subject.alignment = .center

                    expect(subject.collectionView.collectionViewLayout is WLeftAlignedCollectionViewFlowLayout) == false
                }
            }
        }
    }
}
