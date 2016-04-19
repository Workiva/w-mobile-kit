//
//  WActionSheetVCTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WActionSheetVCSpec: QuickSpec {
    override func spec() {
        describe("WActionSheetVCSpec") {
            var subject: WActionSheetVC<NSObject>!
            var action: WAction<NSObject>?
            var table: UITableView!
            var cell1: WTableViewCell<NSObject>!
            var cell2: WTableViewCell<NSObject>!
            var cell3: WTableViewCell<NSObject>!
            
            beforeEach({
                subject = WActionSheetVC<NSObject>()
                action = WAction(title: "Action 1")
                
                subject.addAction(action!)
                subject.addAction(WAction(title: "Action 2", subtitle: "Action 2 Subtitle", image: UIImage()))
                subject.addAction(WAction(title: "Action 3", subtitle: "Action 3 Subtitle"))
                
                subject.titleString = "Title"
                subject.hasCancel = true
                
                table = subject.tableView!
                cell1 = subject.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                cell2 = subject.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                cell3 = subject.tableView(table, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                
                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
                
                table.reloadData()
            })
            
            afterEach({
                subject.animateOut()
            })
            
            describe("when app has been init") {
                it("should have the correct height with cancel") {
                    expect(subject.heightForActionSheet()) == (ROW_HEIGHT * 3) + (CANCEL_SEPARATOR_HEIGHT + ROW_HEIGHT) + (HEADER_HEIGHT)
                }
                
                it("should have the correct height without cancel") {
                    subject.hasCancel = false
                    expect(subject.heightForActionSheet()) == (ROW_HEIGHT * 3) + (HEADER_HEIGHT)
                }
                
                it("should have correct table properties") {
                    expect(subject.tableView(table, numberOfRowsInSection: 0)).to(equal(3))
                    expect(subject.tableView(table, numberOfRowsInSection: 1)).to(equal(0))
                    expect(table.numberOfSections).to(equal(1))
                }
                
                it("should have correct cell properties for destructive only separator style") {
                    expect(cell2.separatorBar.hidden).to(equal(true))
                }
                
                it("should have correct cell properties for all separator style") {
                    subject.sheetSeparatorStyle = .All
                    cell3 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell3.separatorBar.hidden).to(equal(false))
                }
            }
            
            describe("cell selection") {
                it("should select correctly") {
                    subject.tableView(table, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                }
            }
            
            describe("when cell action has been selected") {
                it("should have the correct properties selected by index") {
                    subject.setSelectedAction(1)
                    cell2 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell2.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties selected by action") {
                    subject.setSelectedAction(action!)
                    cell1 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell1.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled by index") {
                    subject.toggleSelectedAction(1)
                    cell2 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell2.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by index") {
                    subject.toggleSelectedAction(1)
                    subject.toggleSelectedAction(1)
                    cell2 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell2.isSelectedAction).to(equal(false))
                }
                
                it("should have the correct properties toggled by action") {
                    subject.toggleSelectedAction(action!)
                    cell1 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell1.selectBar.hidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by action") {
                    subject.toggleSelectedAction(action!)
                    subject.toggleSelectedAction(action!)
                    cell1 = table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! WTableViewCell<NSObject>
                    
                    expect(cell1.isSelectedAction).to(equal(false))
                }
                
                it("should have the correct properties when deselecting all") {
                    subject.deselectAllActions()
                    
                    expect(cell1.isSelectedAction).to(equal(false))
                    expect(cell2.isSelectedAction).to(equal(false))
                    expect(cell3.isSelectedAction).to(equal(false))
                }
                
                it("should have the correct properties when deselecting previous selection") {
                    subject.setSelectedAction(2)
                    subject.deselectAction()
                    
                    expect(cell2.isSelectedAction).to(equal(false))
                }
                
                it("should return if selecting action that does not exist") {
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject.setSelectedAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
                
                it("should return if toggling action that does not exist") {
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject.toggleSelectedAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
                
                it("should return if deselecting action that does not exist") {
                    let selected1 = cell1.isSelectedAction
                    let selected2 = cell2.isSelectedAction
                    let selected3 = cell3.isSelectedAction
                    
                    subject.deselectAction(4)
                    
                    expect(cell1.isSelectedAction).to(equal(selected1))
                    expect(cell2.isSelectedAction).to(equal(selected2))
                    expect(cell3.isSelectedAction).to(equal(selected3))
                }
            }
        }
    }
}