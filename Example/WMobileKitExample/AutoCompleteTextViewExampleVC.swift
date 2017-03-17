//
//  AutoFillTextViewExampleVC.swift
//  WMobileKitExample
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

import Foundation
import WMobileKit

let autoCellIdentifier = "autoCompleteCell"

public class AutoCompleteTextViewExampleVC: WSideMenuContentVC {
    public var searchResults = [String]()
    public var autoCompleteView = WAutoCompleteTextView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // These values are not set by default, must be set for full functionality
        autoCompleteView.controlPrefix = "@"
        autoCompleteView.dataSource = self
        autoCompleteView.delegate = self
        autoCompleteView.autoCompleteTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: autoCellIdentifier)
        
        // These values have defaults, but are set differently for the example
        autoCompleteView.autoCompleteTable.rowHeight = 40
        autoCompleteView.maxAutoCompleteHeight = 130
        
        // These values are already set by default, shown here for the example
        autoCompleteView.addSpaceAfterReplacement = true
        autoCompleteView.replacesControlPrefix = false
        autoCompleteView.numCharactersBeforeAutoComplete = 1
        
        view.addSubview(autoCompleteView)
    }
}

// MARK: Table View Data Source
//       Must be implemented for auto completion
extension AutoCompleteTextViewExampleVC: WAutoCompleteTextViewDataSource {
    public func heightForAutoCompleteTable(textView: WAutoCompleteTextView) -> CGFloat {
        return CGFloat(searchResults.count * 40)
    }
    
    public func didChangeAutoCompletionPrefix(textView: WAutoCompleteTextView, prefix: String, word: String) {
        searchResults.removeAll()
        
        // For the example, just show options of whatever the user typed with 1-4 appended to end
        for i in 1...4 {
            searchResults.append(word.stringByAppendingString(String(i)))
        }
        autoCompleteView.showAutoCompleteTable()
    }
}

extension AutoCompleteTextViewExampleVC: UITableViewDataSource {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Auto completion cells show data from search results
        let cell = tableView.dequeueReusableCellWithIdentifier(autoCellIdentifier)!
        if (indexPath.row < searchResults.count) {
            cell.textLabel?.text = searchResults[indexPath.row]
        }
        cell.userInteractionEnabled = true
        
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

// MARK: Auto Complete Text View Delegate
//       Must be implemented for auto completion
extension AutoCompleteTextViewExampleVC: WAutoCompletionTextViewDelegate {
    public func didSelectAutoCompletion(data: AnyObject) {
        // Word was chosen, called after word has been replaced
    }
}
