//
//  WSideMenuVCTests.swift
//  WSideMenuVCTests

import Quick
import Nimble
@testable import WMobileKit

class WSideMenuVCSpec: QuickSpec {
    override func spec() {
        describe("WSideMenuVCSpec") {
            var sideMenuVC: WSideMenuVC!
            var mainViewVC: UIViewController!
            var leftSideMenuVC: UIViewController!

            beforeEach({
                mainViewVC = UIViewController()
                leftSideMenuVC = UIViewController()
            })

            describe("when app has been init"){
                it("should have the correct properties set"){
                    sideMenuVC = WSideMenuVC(mainViewController: mainViewVC, leftSideMenuViewController: leftSideMenuVC)
                    expect(sideMenuVC.mainViewController).to(equal(mainViewVC))
                    expect(sideMenuVC.leftSideMenuViewController).to(equal(leftSideMenuVC))
                }
            }
        }
    }
}