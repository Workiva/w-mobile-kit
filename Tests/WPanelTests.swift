//
//  WPanelTests.swift
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

class WPanelSpec: QuickSpec {
    override func spec() {
        describe("WPanelSpec") {
            var subject: WPagingPanelVC!
            var window: UIWindow!

            var vc1: WSideMenuContentVC?
            var vc2: WSideMenuContentVC?
            var vc3: WSideMenuContentVC?

            var pages: [UIViewController]!

            beforeEach({
                subject = WPagingPanelVC()

                vc1 = WSideMenuContentVC()
                vc2 = WSideMenuContentVC()
                vc3 = WSideMenuContentVC()

                vc1!.view.backgroundColor = .greenColor()
                vc2!.view.backgroundColor = .blueColor()
                vc3!.view.backgroundColor = .redColor()

                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                pages = [vc1!, vc2!, vc3!]

                subject.pages = pages
            })

            describe("when app has been init") {
                it("should have floating button visible with panel snapped to bottom") {
                    expect(subject.floatingButton.hidden) == false
                    expect(subject.panelView.frame.height) == subject.cornerRadius
                    expect(subject.panelView.frame.origin.y) == subject.view.frame.height
                }

                it("should move panel up based on ratio and hide floating button") {
                    let middleSnapRatio = subject.snapHeights[1]
                    let snapOffset = subject.view.frame.height * (1 - middleSnapRatio)

                    subject.movePanelToSnapRatio(middleSnapRatio, animated: false)

                    expect(subject.panelView.frame.origin.y).to(beCloseTo(snapOffset, within: 0.1))
                    expect(subject.floatingButton.hidden) == true
                }

                it("should panel up based on offset value and hide floating button") {
                    subject.movePanelToValue(100, animated: false)

                    expect(subject.panelView.frame.origin.y) == subject.view.frame.height - 100
                    expect(subject.floatingButton.hidden) == true
                }

                it("should reveal floating button when panel is moved to 0") {
                    subject.movePanelToValue(100, animated: false)
                    subject.movePanelToValue(0, animated: false)

                    expect(subject.panelView.frame.origin.y) == subject.view.frame.height
                    expect(subject.floatingButton.hidden) == false
                }

                it("should reveal vertical panel when pressing floating button") {
                    subject.widthCapForSidePanel = 1000
                    subject.floatingButtonWasPressed(subject.floatingButton)

                    expect(subject.floatingButton.hidden) == true
                    expect(subject.panelView.frame.origin.y).to(beCloseTo(subject.view.frame.height * (1 - subject.snapHeights[1]), within: 0.1))
                }

                it("should reveal side panel when pressing floating button") {
                    subject.widthCapForSidePanel = 100
                    subject.floatingButtonWasPressed(subject.floatingButton)

                    expect(subject.floatingButton.hidden) == true
                    expect(subject.panelView.frame.origin.x) == subject.view.frame.width - subject.sidePanelWidth
                }

                it("should return correct snap ratio values") {
                    subject.snapHeights = [0.0, 0.2, 0.4, 1.0]

                    expect(subject.getLargestSnapRatio()) == 1.0
                    expect(subject.getSmallestSnapRatio()) == 0.0
                    expect(subject.getNextSnapRatio(0.2)) == 0.4
                    expect(subject.getNextSnapRatio(1.0)).to(beNil())
                    expect(subject.getPreviousSnapRatio(1.0)) == 0.4
                    expect(subject.getPreviousSnapRatio(0)).to(beNil())
                }
            }

            describe("property setters") {
                it("should change sidePanel property when changing width cap") {
                    subject.widthCapForSidePanel = 100
                    expect(subject.sidePanel) == true

                    subject.widthCapForSidePanel = 1000
                    expect(subject.sidePanel) == false
                }

                it("should change if panel covers content by changing cap") {
                    subject.sidePanelCoversContentUpToWidth = 1000
                    expect(subject.sidePanelCoversContent) == true

                    subject.sidePanelCoversContentUpToWidth = 100
                    expect(subject.sidePanelCoversContent) == false
                }

                it("shoud widen side panel when increasing width property") {
                    subject.widthCapForSidePanel = 100
                    subject.movePanelToSnapRatio(0.4, animated: false)

                    subject.sidePanelWidth = 300
                    expect(subject.panelView.frame.width) == 300

                    subject.sidePanelWidth = 400
                    expect(subject.panelView.frame.width) ==  400
                }

                it("should change border properties on panel view when modified on vc") {
                    expect(subject.panelView.layer.borderWidth) == 0.5
                    expect(subject.panelView.layer.borderColor) == UIColor.lightGrayColor().CGColor

                    let newWidth: CGFloat = 5
                    let newColor = UIColor.purpleColor().CGColor

                    subject.outlineWidth = newWidth
                    subject.outlineColor = newColor

                    expect(subject.panelView.layer.borderWidth) == newWidth
                    expect(subject.panelView.layer.borderColor) == newColor
                }

                it("should modify cornerRadius and frame when changing property") {
                    let newRadius: CGFloat = 10
                    subject.cornerRadius = newRadius

                    expect(subject.panelView.layer.cornerRadius) == newRadius
                    expect(subject.panelView.frame.height) == newRadius
                }

                it("should show paging control if set to always show") {
                    expect(subject.pagingVC.pagingView.hidden) == false

                    subject.pages = [UIViewController]()
                    expect(subject.pagingVC.pagingView.hidden) == true

                    subject.alwaysShowPagingBar = true
                    expect(subject.pagingVC.pagingView.hidden) == false
                }

                it("should change paging control height") {
                    subject.pagingControlHeight = 200
                    expect(subject.pagingVC.pagingView.frame.height) == 200
                }

                it("should change paging indicator color") {
                    let currentColor = UIColor.redColor()
                    let indicatorColor = UIColor.greenColor()

                    subject.pagingVC.pagingView.currentPageIndicatorTintColor = currentColor
                    subject.pagingVC.pagingView.pageIndicatorTintColor = indicatorColor

                    expect(subject.pagingVC.pagingView.pagingControl.currentPageIndicatorTintColor) == currentColor
                    expect(subject.pagingVC.pagingView.pagingControl.pageIndicatorTintColor) == indicatorColor
                }
            }

            describe("panel delegate methods") {
                it("should return correct side panel value") {
                    subject.widthCapForSidePanel = 100
                    expect(subject.isSidePanel()) == true

                    subject.widthCapForSidePanel = 1000
                    expect(subject.isSidePanel()) == false
                }

                it("should move side panel to ratio correctly") {
                    let middleSnapRatio = subject.snapHeights[1]
                    let snapOffset = subject.view.frame.height * (1 - middleSnapRatio)

                    subject.setPanelRatio(middleSnapRatio, animated: false)

                    expect(subject.panelView.frame.origin.y).to(beCloseTo(snapOffset, within: 0.1))
                    expect(subject.floatingButton.hidden) == true
                }

                it("should panel up based on offset value and hide floating button") {
                    subject.setPanelOffset(100, animated: false)

                    expect(subject.panelView.frame.origin.y) == subject.view.frame.height - 100
                    expect(subject.floatingButton.hidden) == true
                }
            }

            describe("panel gestures") {
                it ("should move panel to pan gesture location") {
                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Changed
                    recognizer.returnPoint = subject.view.center

                    subject.widthCapForSidePanel = 1000

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset).to(beCloseTo(subject.view.frame.height / 2, within: 0.1))
                }

                it ("should not move panel past max height") {
                    subject.snapHeights = [0.0, 0.2, 0.4]

                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Changed
                    recognizer.returnPoint = CGPointZero

                    subject.widthCapForSidePanel = 1000

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset).to(beCloseTo(subject.view.frame.height * 0.42, within: 0.1))
                }

                it ("should move side panel to pan gesture location") {
                    let frame = subject.view.frame
                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Changed
                    recognizer.returnPoint = CGPoint(x: frame.width - 50, y: 0)

                    subject.widthCapForSidePanel = 100

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset).to(beCloseTo(50, within: 0.1))
                }

                it ("should not move side panel past max width") {
                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Changed
                    recognizer.returnPoint = CGPointZero

                    subject.widthCapForSidePanel = 100

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset).to(beCloseTo(subject.sidePanelWidth, within: 0.1))
                }

                it("should snap side panel to side panel width") {
                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Ended
                    recognizer.returnPoint = CGPoint(x: subject.view.frame.width - subject.sidePanelWidth + 10, y: 0)

                    subject.widthCapForSidePanel = 100

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset) == subject.sidePanelWidth
                }

                it("should snap side panel to beyond the view") {
                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Ended
                    recognizer.returnPoint = CGPoint(x: subject.view.frame.width - 10, y: 0)

                    subject.widthCapForSidePanel = 100

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelOffset) == 0
                }

                it("should snap side panel to closest ratio") {
                    subject.snapHeights = [0.0, 0.4]

                    let recognizer = UIPanGestureRecognizerMock()
                    recognizer.testState = .Ended
                    recognizer.returnPoint = CGPoint(x: 0, y: subject.view.frame.height - 10)

                    subject.panelWasPanned(recognizer)

                    expect(subject.currentPanelRatio) == 0.0
                }

                it("should hide panel when tapped") {
                    subject.movePanelToSnapRatio(0.4)
                    expect(subject.currentPanelRatio) == 0.4

                    let recognizer = UIPanGestureRecognizerMock()
                    subject.panelWasTapped(recognizer)

                    expect(subject.currentPanelRatio) == 0.0
                }

                it("should hide side panel when tapped") {
                    subject.widthCapForSidePanel = 100

                    subject.movePanelToValue(subject.sidePanelWidth)
                    expect(subject.currentPanelOffset) == subject.sidePanelWidth

                    let recognizer = UIPanGestureRecognizerMock()
                    subject.panelWasTapped(recognizer)

                    expect(subject.currentPanelOffset) == 0.0
                }
            }

            describe("page manager") {
                it("should return correct next view controller") {
                    let pagingManager = subject.pagingVC.pagingManager
                    expect(pagingManager.pageViewController(pagingManager, viewControllerAfterViewController: vc1!)) == vc2
                    expect(pagingManager.pageViewController(pagingManager, viewControllerAfterViewController: vc2!)) == vc3
                    expect(pagingManager.pageViewController(pagingManager, viewControllerAfterViewController: vc3!)).to(beNil())
                }

                it("should return correct previous view controller") {
                    let pagingManager = subject.pagingVC.pagingManager
                    expect(pagingManager.pageViewController(pagingManager, viewControllerBeforeViewController: vc1!)).to(beNil())
                    expect(pagingManager.pageViewController(pagingManager, viewControllerBeforeViewController: vc2!)) == vc1
                    expect(pagingManager.pageViewController(pagingManager, viewControllerBeforeViewController: vc3!)) == vc2
                }
            }
        }
    }
}
