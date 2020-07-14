//
//  WActionSheetVCTests.swift
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

class WActionSheetSpec: QuickSpec {
    override func spec() {
        describe("WActionSheetSpec") {
            var subject: WActionSheetVC<Any>!
            var action: WAction<Any>!
            var table: UITableView!
            var cell1: WTableViewCell<Any>!
            var cell2: WTableViewCell<Any>!
            var cell3: WTableViewCell<Any>!
            
            beforeEach {
                subject = WActionSheetVC<Any>()
                action = WAction(title: "Action 1")
                
                subject.addAction(action!)
                subject.addAction(WAction(title: "Action 2", subtitle: "Action 2 Subtitle", image: UIImage()))
                subject.addAction(WAction(title: "Action 3", subtitle: "Action 3 Subtitle"))
                
                subject.titleString = "Title"
                subject.hasCancel = true
                
                table = subject.tableView
                cell1 = subject.tableView(table, cellForRowAt: IndexPath(row: 0, section: 0)) as! WTableViewCell<Any>
                cell2 = subject.tableView(table, cellForRowAt: IndexPath(row: 1, section: 0)) as! WTableViewCell<Any>
                cell3 = subject.tableView(table, cellForRowAt: IndexPath(row: 2, section: 0)) as! WTableViewCell<Any>
                
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
                
                table.reloadData()
            }
            
            describe("when app has been init") {
                it("should have the correct height with cancel") {
                    expect(subject.heightForActionSheet()) == (ROW_HEIGHT * 3) + (CANCEL_SEPARATOR_HEIGHT + CANCEL_HEIGHT) + (HEADER_HEIGHT)
                }
                
                it("should have the correct height without cancel") {
                    subject.hasCancel = false
                    expect(subject.heightForActionSheet()) == (ROW_HEIGHT * 3) + (HEADER_HEIGHT)
                }

                it("should have the correct content height with title") {
                    expect(subject.heightForSheetContent()) == (ROW_HEIGHT * 3) + (HEADER_HEIGHT)
                }

                it("should have the correct content height without title") {
                    subject.titleString = nil
                    subject.hasCancel = false
                    expect(subject.heightForSheetContent()) == (ROW_HEIGHT * 3)
                }
                
                it("should have correct table properties") {
                    expect(subject.tableView(table, numberOfRowsInSection: 0)).to(equal(3))
                    expect(subject.tableView(table, numberOfRowsInSection: 1)).to(equal(0))
                    expect(table.numberOfSections).to(equal(1))
                }
                
                it("should have correct cell properties for destructive only separator style") {
                    expect(cell2.separatorBar.isHidden).to(equal(true))
                }
                
                it("should have correct cell properties for all separator style") {
                    subject.sheetSeparatorStyle = .all
                    cell3 = table.cellForRow(at: IndexPath(row: 2, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell3.separatorBar.isHidden).to(equal(false))
                }
                
                it("should init table cell with coder correctly") {
                    let tableCell = WTableViewCell<Any>(frame: CGRect.zero)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WTableViewCell")

                    NSKeyedArchiver.archiveRootObject(tableCell, toFile: locToSave)

                    let newTableCell = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WTableViewCell<Any>

                    expect(newTableCell).toNot(beNil())
                    expect(newTableCell.selectBar.isHidden).to(equal(true))
                    expect(newTableCell.separatorBar).toNot(beNil())
                }

                it("should init table header with coder correctly") {
                    let headerView = WHeaderView(frame: CGRect.zero)

                    let path = NSTemporaryDirectory() as NSString
                    let locToSave = path.appendingPathComponent("WHeaderView")

                    NSKeyedArchiver.archiveRootObject(headerView, toFile: locToSave)

                    let newHeaderView = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as! WHeaderView

                    expect(newHeaderView).toNot(beNil())
                }

                it("should have default status bar settings") {
                    expect(subject.prefersStatusBarHidden) == false
                    expect(subject.preferredStatusBarStyle) == UIStatusBarStyle.default
                }
                
                it("should use stored settings for status bar style") {
                    subject.previousStatusBarStyle = .lightContent
                    subject.previousStatusBarHidden = true
                    
                    expect(subject.statusBarStyleController.prefersStatusBarHidden) == true
                    expect(subject.statusBarStyleController.preferredStatusBarStyle) == UIStatusBarStyle.lightContent
                }
                
                it("should set window and subview properties correctly") {
                    expect(subject.presentingWindow).toNot(beNil())
                    expect(subject.presentingWindow!.isHidden) == false
                    expect(subject.presentingWindow!.windowLevel) == UIWindow.Level.statusBar + 1
                    expect(subject.presentingWindow!.rootViewController) == subject.statusBarStyleController
                    
                    expect(subject.tapRecognizerView.backgroundColor) == UIColor.black.withAlphaComponent(0.4)
                    expect(subject.tapRecognizerView.gestureRecognizers?.count) == 1
                }

                it("should create a window if it does not exist when appearing") {
                    subject.presentingWindow = nil
                    subject.viewWillAppear(false)

                    expect(subject.presentingWindow).toNot(beNil())
                }

                it("should overlay a transparent white view and not highlight if action is disabled") {
                    subject.actions[1].enabled = false
                    table.reloadData()

                    let indexPath = IndexPath(row: 1, section: 0)
                    let disabledCell = table.cellForRow(at: indexPath)

                    expect(disabledCell!.subviews[disabledCell!.subviews.count - 1].backgroundColor) == UIColor.white.withAlphaComponent(0.5)
                    expect(subject.tableView(table, shouldHighlightRowAt: indexPath)) == false
                }
            }

            describe("max sheet height") {
                it("should have a max sheet height of 80% of the sheet height if a max height is not set") {
                    expect(subject.defaultMaxSheetHeight()) == UIScreen.main.bounds.size.height * 0.8
                }

                it("should use a custom max sheet height if a custom value is set") {
                    subject.maxSheetHeight = 200.0

                    expect(subject.maxSheetHeight) == 200.0
                }
            }
            
            describe("cell selection") {
                it("should select correctly") {
                    subject.tableView(table, didSelectRowAt: IndexPath(row: 0, section: 0))
                }
            }
            
            describe("when cell action has been selected") {
                it("should have the correct properties selected by index") {
                    subject.setSelectedAction(1)
                    cell2 = table.cellForRow(at: IndexPath(row: 1, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell2.selectBar.isHidden).to(equal(false))
                }
                
                it("should have the correct properties selected by action") {
                    subject.setSelectedAction(action!)
                    cell1 = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell1.selectBar.isHidden).to(equal(false))
                }
                
                it("should have the correct properties toggled by index") {
                    subject.toggleSelectedAction(1)
                    cell2 = table.cellForRow(at: IndexPath(row: 1, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell2.selectBar.isHidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by index") {
                    subject.toggleSelectedAction(1)
                    subject.toggleSelectedAction(1)
                    cell2 = table.cellForRow(at: IndexPath(row: 1, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell2.isSelectedAction).to(equal(false))
                }
                
                it("should have the correct properties toggled by action") {
                    subject.toggleSelectedAction(action!)
                    cell1 = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! WTableViewCell<Any>
                    
                    expect(cell1.selectBar.isHidden).to(equal(false))
                }
                
                it("should have the correct properties toggled twice by action") {
                    subject.toggleSelectedAction(action!)
                    subject.toggleSelectedAction(action!)
                    cell1 = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! WTableViewCell<Any>
                    
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
            var subject: WPickerActionSheet<Any>!
            var action: WAction<Any>!

            beforeEach {
                subject = WPickerActionSheet<Any>()
                action = WAction(title: "Option 1")

                subject.addAction(action!)
                subject.addAction(WAction(title: "Option 2", image: UIImage()))
                subject.addAction(WAction(title: "Option 3"))
                subject.addAction(WAction(title: "Option 4"))
                subject.addAction(WAction(title: "Option 5"))

                subject.hasCancel = true

                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                subject.pickerView.reloadAllComponents()
            }

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
                    expect(subject.toolbarContainerView.subviews.contains(subject.toolbarCancelButton)) == true
                    expect(subject.toolbarContainerView.subviews.contains(subject.toolbarDoneButton)) == true

                    // Properties are all set up
                    expect(subject.toolbarDoneButton.title(for: .normal)) == "Done"
                    expect(subject.toolbarDoneButton.titleColor(for: .normal)) == .blue

                    expect(subject.toolbarContainerView.backgroundColor) == .white
                    expect(subject.pickerView.backgroundColor) == .white
                }

                it("should have the correct height for having actions") {
                    expect(subject.heightForActionSheet()) == subject.PICKER_VIEW_HEIGHT
                }
            }

            describe("pickerview row can be selected") {
                it("with a valid row") {
                    subject.pickerView.selectRow(1, inComponent: 0, animated: true)
                }

                it("with an invalid row number") {
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
                    expect(subject.pickerView.numberOfRows(inComponent: 0)).to(equal(5))
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
