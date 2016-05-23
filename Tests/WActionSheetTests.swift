//
//  WActionSheetVCTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WActionSheetSpec: QuickSpec {
    override func spec() {
        describe("WActionSheetSpec") {
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
                
                table = subject.tableView
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
                    expect(subject.heightForActionSheet()) == (ROW_HEIGHT * 3) + (CANCEL_SEPARATOR_HEIGHT + CANCEL_HEIGHT) + (HEADER_HEIGHT)
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
                
                it("should init table cell with coder correctly") {
                    let tableCell = WTableViewCell<NSObject>(frame: CGRectZero)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("testsActionSheet")
                    
                    NSKeyedArchiver.archiveRootObject(tableCell, toFile: locToSave)
                    
                    let newTableCell = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WTableViewCell<NSObject>
                    
                    expect(newTableCell).toNot(equal(nil))
                    expect(newTableCell.selectBar.hidden).to(equal(true))
                    expect(newTableCell.separatorBar).toNot(equal(nil))
                }
                
                it("should init table header with coder correctly") {
                    let headerView = WHeaderView(frame: CGRectZero)
                    
                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.stringByAppendingPathComponent("testsActionSheet")
                    
                    NSKeyedArchiver.archiveRootObject(headerView, toFile: locToSave)
                    
                    let newHeaderView = NSKeyedUnarchiver.unarchiveObjectWithFile(locToSave) as! WHeaderView
                    
                    expect(newHeaderView).toNot(equal(nil))
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

        describe("WPickerActionSheetVCSpec") {
            var subject: WPickerActionSheet<NSObject>!
            var action: WAction<NSObject>?

            beforeEach({
                subject = WPickerActionSheet<NSObject>()
                action = WAction(title: "Option 1")

                subject.addAction(action!)
                subject.addAction(WAction(title: "Option 2", image: UIImage()))
                subject.addAction(WAction(title: "Option 3"))
                subject.addAction(WAction(title: "Option 4"))
                subject.addAction(WAction(title: "Option 5"))

                subject.hasCancel = true

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                subject.pickerView.reloadAllComponents()
            })

            afterEach({
                subject.animateOut()
            })

            describe("when app has been init") {
                it("should have everything initalized properly") {
                    // Delegate assignment
                    expect(subject.pickerView.delegate).toNot(beNil())
                    expect(subject.delegate).toNot(beNil())

                    // Everything exists
                    expect(subject.toolbarContainerView).toNot(beNil())
                    expect(subject.toolbarDoneButton).toNot(beNil())
                    expect(subject.toolbarCancelButton).toNot(beNil())
                    expect(subject.pickerView).toNot(beNil())

                    // All views added programatically
                    expect(subject.toolbarContainerView.subviews.contains(subject.toolbarCancelButton)).to(beTruthy())
                    expect(subject.toolbarContainerView.subviews.contains(subject.toolbarDoneButton)).to(beTruthy())

                    // Properties are all set up
                    expect(subject.toolbarCancelButton.titleLabel?.text).to(equal("Cancel"))
                    expect(subject.toolbarCancelButton.titleLabel?.textColor).to(equal(UIColor.blueColor()))
                    expect(subject.toolbarCancelButton.allTargets().contains(subject)).to(beTruthy())

                    expect(subject.toolbarDoneButton.titleLabel?.text).to(equal("Done"))
                    expect(subject.toolbarDoneButton.titleLabel?.textColor).to(equal(UIColor.blueColor()))
                    expect(subject.toolbarDoneButton.allTargets().contains(subject)) == true

                    expect(subject.toolbarContainerView.backgroundColor).to(equal(UIColor.whiteColor()))
                    expect(subject.pickerView.backgroundColor).to(equal(UIColor.whiteColor()))
                }

                it("should have the correct height for having actions") {
                    expect(subject.heightForActionSheet()).to(equal(subject.PICKER_VIEW_HEIGHT))
                }
            }

            describe("pickerview row can be selected") {
                it("with a valid row") {
                    subject.pickerView.selectRow(1, inComponent: 0, animated: true)
                }

                it("with an invlaid row number") {
                    subject.pickerView.selectRow(9, inComponent: 0, animated: true)
                }
            }

            describe("toolbar buttons") {
                it("should successfully touch done button") {
                    subject.toolbarDoneButtonWasTouched()
                }

                it("should successfully touch cancel button") {
                    subject.toolbarCancelButtonWasTouched()
                }
            }

            describe("pickerview delegate method calls") {
                it("should have the correct number of rows") {
                    expect(subject.pickerView.numberOfRowsInComponent(0)).to(equal(5))
                }

                it("should have the correct number of components") {
                    expect(subject.pickerView.numberOfComponents) == 1
                }

                it("should select correctly") {
                    subject.pickerView(subject.pickerView, didSelectRow: 0, inComponent: 0)
                }
            }
        }
    }
}