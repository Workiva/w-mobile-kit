//
//  AutoFillTextFieldExampleVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class AutoCompleteTextFieldExampleVC: WSideMenuContentVC {
    public var searchResults = [String]()
    public var textField = WAutoCompleteTextView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.controlPrefix = "@"
        textField.autoCompleteTable.dataSource = self
        textField.maxAutoCompleteHeight = 130
        textField.delegate = self
        textField.autoCompleteTable.rowHeight = 40
        
        // These values are already set by default, shown here regardless due to having one example
        textField.addSpaceAfterReplacement = true
        textField.replacesControlPrefix = false
        textField.numCharactersBeforeAutoComplete = 1
        
        view.addSubview(textField)
    }
}

extension AutoCompleteTextFieldExampleVC : UITableViewDataSource {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        if (indexPath.row < searchResults.count) {
            cell.textLabel?.text = searchResults[indexPath.row]
        }
        cell.userInteractionEnabled = true
        
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension AutoCompleteTextFieldExampleVC : WAutoCompleteTextViewDelegate {
    public func didChangeAutoCompletionPrefix(prefix: String, word: String) {
        searchResults.removeAll()
        
        for i in 1...4 {
            searchResults.append(word.stringByAppendingString(String(i)))
        }
    }
}