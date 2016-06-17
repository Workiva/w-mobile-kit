//
//  WPagingSelectorVCTests.swift
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

class WPagingSelectorVCSpec: QuickSpec {
    override func spec() {
        describe("WPagingSelectorVCSpec") {
            var subject: WPagingSelectorVC!
            var window: UIWindow!

            var vc1: WSideMenuContentVC?
            var vc2: WSideMenuContentVC?
            var vc3: WSideMenuContentVC?

            var pages: [WPage]!
            var titles: [String]!

            beforeEach({
                subject = WPagingSelectorVC()

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

                titles = [
                    "Green VC",
                    "Blue VC",
                    "Red VC"
                ]

                pages = [
                    WPage(title: titles[0], viewController: vc1),
                    WPage(title: titles[1], viewController: vc2),
                    WPage(title: titles[2], viewController: vc3)
                ]

                subject.pages = pages
            })

            describe("when app has been init") {
                it("should have the correct properties set") {
                    subject.tabWidth = DEFAULT_TAB_WIDTH

                    expect(subject.tabWidth).to(equal(DEFAULT_TAB_WIDTH))
                    expect(subject.pagingControlHeight).to(equal(DEFAULT_PAGING_SELECTOR_HEIGHT))
                    expect(subject.tabTextColor).to(equal(UIColor.blackColor()))
                }
            }

            describe("tabs") { 
                it("should change tabs to the indexed tab") {
                    subject.willChangeToTab(subject.pagingSelectorControl!, tab: 0)
                }

                it("should change current index to the tab") {
                    subject.didChangeToTab(subject.pagingSelectorControl!, tab: 0)

                    expect(subject.currentPageIndex).to(equal(0))

                    subject.didChangeToTab(subject.pagingSelectorControl!, tab: 1)

                    expect(subject.currentPageIndex).to(equal(1))
                }
            }

            describe("WTabView") {
                var tabView: WTabView!

                afterEach({
                    tabView = nil
                })

                it("should init with coder correctly and verify commonInit") {
                    tabView = WTabView(title: "Tab")

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WTabView")

                    NSKeyedArchiver.archiveRootObject(tabView, toFile: locToSave)

                    let tabView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTabView

                    expect(tabView).toNot(equal(nil))

                    // default settings from commonInit
                }
            }

            describe("WSelectionIndicatorView") {
                var selectionIndicatorView: WSelectionIndicatorView!

                afterEach({
                    selectionIndicatorView = nil
                })

                it("should init with coder correctly and verify commonInit") {
                    selectionIndicatorView = WSelectionIndicatorView()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WSelectionIndicatorView")

                    NSKeyedArchiver.archiveRootObject(selectionIndicatorView, toFile: locToSave)

                    let selectionIndicatorView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WSelectionIndicatorView

                    expect(selectionIndicatorView).toNot(equal(nil))
                    
                    // default settings from commonInit
                }
            }

            describe("WPagingSelectorControl") {
                var pagingSelectorControl: WPagingSelectorControl!

                afterEach({
                    pagingSelectorControl = nil
                })

                it("should init with coder correctly and verify commonInit") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WPagingSelectorControl")

                    NSKeyedArchiver.archiveRootObject(pagingSelectorControl, toFile: locToSave)

                    let pagingSelectorControl = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WPagingSelectorControl

                    expect(pagingSelectorControl).toNot(equal(nil))
                    
                    // default settings from commonInit
                }

                it("should init with titles") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles)

                    expect(pagingSelectorControl).toNot(beNil())
                }

                it("should init with titles and tabWidth") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles, tabWidth: 40)

                    expect(pagingSelectorControl).toNot(beNil())
                }

                it("should init with pages") {
                    pagingSelectorControl = WPagingSelectorControl(pages: pages)

                    expect(pagingSelectorControl).toNot(beNil())
                }
            }
        }
    }
}