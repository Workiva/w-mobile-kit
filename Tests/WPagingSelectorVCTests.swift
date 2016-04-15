//
//  WPagingSelectorVCTests.swift
//  WPagingSelectorVCTests

import Quick
import Nimble
@testable import WMobileKit

class WPagingSelectorVCSpec: QuickSpec {
    override func spec() {
        describe("WPagingSelectorVCSpec") {
            var subject: WPagingSelectorVC?

            var vc1: WSideMenuContentVC?
            var vc2: WSideMenuContentVC?
            var vc3: WSideMenuContentVC?

            var pages: [WPage]?

            beforeEach({
                subject = WPagingSelectorVC()

                vc1 = WSideMenuContentVC()
                vc2 = WSideMenuContentVC()
                vc3 = WSideMenuContentVC()

                vc1!.view.backgroundColor = UIColor.greenColor()
                vc2!.view.backgroundColor = UIColor.blueColor()
                vc3!.view.backgroundColor = UIColor.redColor()

                pages = [
                    WPage(title: "Green VC", viewController: vc1),
                    WPage(title: "Blue VC", viewController: vc2),
                    WPage(title: "Red VC", viewController: vc3)
                ]
            })

            describe("when app has been init"){
                it("should have the correct properties set"){
                    subject!.pages = pages!

                    subject!.tabWidth = DEFAULT_TAB_WIDTH

                    expect(subject!.tabWidth).to(equal(DEFAULT_TAB_WIDTH))
                    expect(subject!.pagingControlHeight).to(equal(DEFAULT_PAGING_SELECTOR_HEIGHT))
                    expect(subject!.tabTextColor).to(equal(UIColor.blackColor()))
                }
            }
        }
    }
}