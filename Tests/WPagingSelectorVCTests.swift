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

                    expect(subject.tabWidth) == DEFAULT_TAB_WIDTH
                    expect(subject.tabSpacing) == 0.0
                    expect(subject.pagingControlHeight) == DEFAULT_PAGING_SELECTOR_HEIGHT
                    expect(subject.pagingControlSidePadding) == DEFAULT_PAGING_SELECTOR_SIDE_PADDING
                    expect(subject.tabTextColor).to(equal(UIColor.blackColor()))
                }
                
                it("should set to default tab width if trying to set too small of a value") {
                    subject.tabWidth = 1
                    
                    expect(subject.pagingSelectorControl!.tabWidth) == DEFAULT_TAB_WIDTH
                }
                
                it("should remove old paging selector when setting new pages") {
                    let selector = subject.pagingSelectorControl
                    subject.pages =  [WPage(title: "Test")]
                    
                    expect(selector!.superview).to(beNil())
                }
                
                it("should remove old paging selector when setting new height") {
                    let selector = subject.pagingSelectorControl
                    subject.pagingControlHeight = 10
                    
                    expect(selector!.superview).to(beNil())
                }

                it("should remove old paging selector when setting new side padding") {
                    let selector = subject.pagingSelectorControl
                    subject.pagingControlSidePadding = 10

                    expect(selector!.superview).to(beNil())
                }
                
                it("should set color on control when setting on the VC") {
                    subject.tabTextColor = .blueColor()
                    
                    expect(subject.pagingSelectorControl!.tabTextColor) == UIColor.blueColor()
                }
                
                it("should set color for the separator line on control when setting on the VC") {
                    subject.separatorLineColor = .blueColor()
                    
                    expect(subject.pagingSelectorControl!.separatorLineColor) == UIColor.blueColor()
                }
                
                it("should set separator line height on control when setting on the VC") {
                    subject.separatorLineHeight = 3.0
                    
                    expect(subject.pagingSelectorControl!.separatorLineHeight) == 3.0
                }

                it("should remove old paging selector when setting new tab spacing") {
                    let selector = subject.pagingSelectorControl
                    subject.tabSpacing = 20

                    expect(selector!.superview).to(beNil())
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

                it("should init with coder correctly") {
                    tabView = WTabView(title: "Tab")

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WTabView")

                    NSKeyedArchiver.archiveRootObject(tabView, toFile: locToSave)

                    let tabView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTabView

                    expect(tabView).toNot(equal(nil))
                }
            }

            describe("WSelectionIndicatorView") {
                var selectionIndicatorView: WSelectionIndicatorView!

                afterEach({
                    selectionIndicatorView = nil
                })

                it("should init with coder correctly") {
                    selectionIndicatorView = WSelectionIndicatorView()

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WSelectionIndicatorView")

                    NSKeyedArchiver.archiveRootObject(selectionIndicatorView, toFile: locToSave)

                    let selectionIndicatorView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WSelectionIndicatorView

                    expect(selectionIndicatorView).toNot(equal(nil))
                }
            }

            describe("WPagingSelectorControl") {
                var pagingSelectorControl: WPagingSelectorControl!

                afterEach({
                    pagingSelectorControl = nil
                })

                let verifyCommonInit = {
                    expect(pagingSelectorControl.tabTextColor) == UIColor.grayColor()
                    expect(pagingSelectorControl.separatorLineColor) == WThemeManager.sharedInstance.currentTheme.pagingSelectorSeparatorColor
                    expect(pagingSelectorControl.separatorLineHeight) == 1.0
                    expect(pagingSelectorControl.widthMode).to(equal(WPagingWidthMode.Dynamic))
                }

                it("should init with coder correctly and verify commonInit") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("WPagingSelectorControl")

                    NSKeyedArchiver.archiveRootObject(pagingSelectorControl, toFile: locToSave)

                    let pagingSelectorControl = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WPagingSelectorControl

                    expect(pagingSelectorControl).toNot(equal(nil))
                    
                    verifyCommonInit()
                }

                it("should init with titles") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles)

                    expect(pagingSelectorControl).toNot(beNil())
                }

                it("should init with titles and tabWidth") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles, tabWidth: 40)

                    expect(pagingSelectorControl).toNot(beNil())
                }

                it("should init with titles and tabSpacing") {
                    pagingSelectorControl = WPagingSelectorControl(titles: titles, tabWidth: 40, tabSpacing: 15)

                    expect(pagingSelectorControl).toNot(beNil())
                }

                it("should init with pages") {
                    pagingSelectorControl = WPagingSelectorControl(pages: pages)

                    expect(pagingSelectorControl).toNot(beNil())
                }
            }
            
            describe("PagingSelectorControl Shadow") {
                var delegate: WPagingSelectorControlVCDelegateMock!
                
                beforeEach({
                    delegate = WPagingSelectorControlVCDelegateMock()
                    
                    subject.pages = [WPage(title: "Test"), WPage(title: "Test 2", viewController: delegate)]
                    delegate.scrollView.delegate = subject
                })
                
                it("should check with delegate when changing tabs") {
                    expect(subject.isShowingShadow) == false
                    
                    subject.willChangeToTab(subject.pagingSelectorControl!, tab: 1)
                    
                    expect(subject.isShowingShadow) == true
                }
                
                it("should show shadow if scrolling and delegate says to show shadow") {
                    delegate.forceShowShadow = false
                    subject.willChangeToTab(subject.pagingSelectorControl!, tab: 1)
                    delegate.forceShowShadow = true
                    
                    expect(subject.isShowingShadow) == false
                    
                    subject.scrollViewDidScroll(delegate.scrollView)
                    
                    expect(subject.isShowingShadow) == true
                }
                
                it("should show shadow if scrolling and content goes above paging selector with no delegate overrides") {
                    delegate.forceShowShadow = false
                    
                    expect(subject.isShowingShadow) == false
                    delegate.scrollView.contentOffset = CGPoint(x: 0, y: 1)
                    subject.scrollViewDidScroll(delegate.scrollView)
                    
                    expect(subject.isShowingShadow) == true
                }
                
                it("should not show shadow if scrolling and no content is behind paging selector with no delegate overrides") {
                    delegate.forceShowShadow = false
                    
                    expect(subject.isShowingShadow) == false
                    delegate.scrollView.contentOffset = CGPoint(x: 0, y: -1)
                    subject.scrollViewDidScroll(delegate.scrollView)
                    
                    expect(subject.isShowingShadow) == false
                }
                
                it("should set shadow properties correctly") {
                    let pagingControl = subject.pagingSelectorControl!
                    let shadowDisabledOpacity: Float = 0.0
                    let shadowColor = UIColor.purpleColor().CGColor
                    let shadowRadius: CGFloat = 5
                    
                    // First call sets up initial properties regardless and verify defaults
                    subject.setShadow(false, animated: false)
                    
                    expect(pagingControl.layer.shadowOpacity) == shadowDisabledOpacity
                    expect(pagingControl.layer.shadowColor) == UIColor.blackColor().CGColor
                    expect(pagingControl.layer.shadowRadius) == 4
                    expect(pagingControl.layer.shadowOffset) == CGSize(width: 0, height: 0)
                    
                    // Change shadow properties
                    subject.shadowColor = shadowColor
                    subject.shadowRadius = shadowRadius
                    
                    // Second call should keep set shadow properties
                    subject.setShadow(false, animated: false)
                    
                    // Verify set properties
                    expect(pagingControl.layer.shadowColor) == shadowColor
                    expect(pagingControl.layer.shadowRadius) == shadowRadius
                }
                
                it("should set shadow properties correctly and immediately with no animation") {
                    let pagingControl = subject.pagingSelectorControl!
                    let shadowEnabledOpacity: Float = 0.3
                    let shadowDisabledOpacity: Float = 0.0
                    
                    // First call sets up initial properties regardless
                    subject.setShadow(false, animated: false)
                    
                    expect(pagingControl.layer.shadowOpacity) == shadowDisabledOpacity
                    expect(pagingControl.layer.shadowColor) == UIColor.blackColor().CGColor
                    expect(pagingControl.layer.shadowRadius) == 4
                    expect(pagingControl.layer.shadowOffset) == CGSize(width: 0, height: 0)
                    
                    // Second call will change opacity to very transparent
                    subject.setShadow(true, animated: false)
                    
                    expect(pagingControl.layer.shadowOpacity) == shadowEnabledOpacity
                    
                    // Third call will change opacity back to completely transparent
                    subject.setShadow(false, animated: false)
                    
                    expect(pagingControl.layer.shadowOpacity) == shadowDisabledOpacity
                }
            }
        }
    }
}

class WPagingSelectorControlVCDelegateMock: WSideMenuContentVC, WPagingSelectorVCDelegate {
    var forceShowShadow = true
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
    }
    
    func shouldShowShadow(sender: WPagingSelectorVC) -> Bool {
        if (forceShowShadow) {
            return forceShowShadow
        }
        
        return scrollView.contentOffset.y > 0
    }
}