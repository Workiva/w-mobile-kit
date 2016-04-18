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
            var action: WAction<NSObject>?
            
            beforeEach({
                subject = WActionSheetVC<NSObject>()
                action = WAction(title: "Action 1")
                
                subject?.addAction(action!)
                subject?.addAction(WAction(title: "Action 2", subtitle: "Action 2 Subtitle", image: UIImage()))
                subject?.addAction(WAction(title: "Action 3", subtitle: "Action 3 Subtitle"))
                
                subject?.titleString = "Title"
                subject?.hasCancel = true
                
                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject?.beginAppearanceTransition(true, animated: false)
                subject?.endAppearanceTransition()
            })
            
            afterEach({
                subject?.animateOut()
            })
            
            describe("when app has been init") {
                it("should have the correct height with cancel") {
                    expect(subject?.heightForActionSheet()) == (ROW_HEIGHT * 3) + (CANCEL_SEPARATOR_HEIGHT + ROW_HEIGHT) + (HEADER_HEIGHT)
                }
                
                it("should have the correct height without cancel") {
                    subject?.hasCancel = false
                    expect(subject?.heightForActionSheet()) == (ROW_HEIGHT * 3) + (HEADER_HEIGHT)
                }
                
                it("should have correct table properties") {
                    let table = subject!.tableView!
                    
                    expect(subject?.tableView(table, numberOfRowsInSection: 0)).to(equal(3))
                    expect(subject?.tableView(table, numberOfRowsInSection: 1)).to(equal(0))
                    expect(table.numberOfSections).to(equal(1))
                }
                
                it("should have correct cell properties for destructive only separator style") {
                    let table = subject!.tableView!
                    let cell = table.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.separatorBar.hidden).to(equal(true))
                }
                
                it("should have correct cell properties for all separator style") {
                    subject?.sheetSeparatorStyle = .All
                    
                    let table = subject!.tableView!
                    let cell = table.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.separatorBar.hidden).to(equal(false))
                }
            }
            
            describe("cell selection") {
                it("should select correctly") {
                    let table = subject!.tableView!
                    
                    subject?.tableView(table, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                }
            }
            
            describe("when cell action has been selected") {
                it("should have the correct properties selected by index") {
                    subject?.setSelectedAction(1)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties selected by action") {
                    subject?.setSelectedAction(action!)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled by index") {
                    subject?.toggleSelectedAction(1)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by index") {
                    subject?.toggleSelectedAction(1)
                    subject?.toggleSelectedAction(1)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.isSelectedAction).to(equal(true))
                }
                
                it("should have the correct properties toggled by action") {
                    subject?.toggleSelectedAction(action!)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by action") {
                    subject?.toggleSelectedAction(action!)
                    subject?.toggleSelectedAction(action!)
                    let table = subject!.tableView!
                    let cell = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell.isSelectedAction).to(equal(true))
                }
                
                it("should have the correct properties when deselecting all") {
                    let table = subject!.tableView!
                    let cell1 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell2 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell3 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    subject?.deselectAllActions()
                    
                    expect(cell1.isSelectedAction).to(equal(false))
                    expect(cell2.isSelectedAction).to(equal(false))
                    expect(cell3.isSelectedAction).to(equal(false))
                }
                
                it("should have the correct properties when deselecting previous selection") {
                    let table = subject!.tableView!
                    let cell2 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    subject?.setSelectedAction(2)
                    subject?.deselectAction()
                    
                    expect(cell2.isSelectedAction).to(equal(false))
                }
                
                it("should return if selecting action that does not exist") {
                    let table = subject!.tableView!
                    let cell1 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell2 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell3 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject?.setSelectedAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
                
                it("should return if toggling action that does not exist") {
                    let table = subject!.tableView!
                    let cell1 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell2 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell3 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject?.toggleSelectedAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
                
                it("should return if deselecting action that does not exist") {
                    let table = subject!.tableView!
                    let cell1 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell2 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    let cell3 = subject?.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject?.deselectAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
                
                
            }
        }
    }
}