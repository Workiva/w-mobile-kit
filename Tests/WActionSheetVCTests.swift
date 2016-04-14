//
//  WActionSheetVCTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WActionSheetVCSpec: QuickSpec {
    override func spec() {
        describe("WActionSheetVCSpec") {
            var subject: WActionSheetVC<NSObject>?
            
            beforeEach({
                subject = WActionSheetVC<NSObject>()
                
                subject?.addAction(WAction(title: "Action 1"))
                subject?.addAction(WAction(title: "Action 2"))
                subject?.addAction(WAction(title: "Action 3"))
                
                subject?.titleString = "Title"
                subject?.hasCancel = true
            })
            
            describe("when app has been init") {
                it("should have the correct properties set") {
                    expect(subject?.heightForActionSheet()) == (ROW_HEIGHT * 3) + (CANCEL_SEPARATOR_HEIGHT + ROW_HEIGHT) + (HEADER_HEIGHT)
                }
                
                it("should have the correct height without cancel") {
                    subject?.hasCancel = false
                    expect(subject?.heightForActionSheet()) == (ROW_HEIGHT * 3) + (HEADER_HEIGHT)
                }
            }
            
            describe("when cell has been selected") {
                it("should have the correct properties set") {
//                    let cell = subject.tableView.cell
                    
                }
            }
        }
    }
}