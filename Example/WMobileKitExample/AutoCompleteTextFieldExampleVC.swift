//
//  AutoFillTextFieldExampleVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

let autoCellIdentifier = "autoCompleteCell"

public class AutoCompleteTextFieldExampleVC: WSideMenuContentVC {
    public var searchResults = [String]()
    public var textView = WAutoCompleteTextView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // These values are not set by default, must be set for full functionality
        textView.controlPrefix = "@"
        textView.dataSource = self
        textView.delegate = self
        textView.autoCompleteTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: autoCellIdentifier)
        
        // These values have defaults, but are set differently for the example
        textView.autoCompleteTable.rowHeight = 40
        textView.maxAutoCompleteHeight = 130
        
        // These values are already set by default, shown here for the example
        textView.addSpaceAfterReplacement = true
        textView.replacesControlPrefix = false
        textView.numCharactersBeforeAutoComplete = 1
        
        view.addSubview(textView)
    }
}

// MARK: Table View Data Source
//       Must be implemented for auto completion
extension AutoCompleteTextFieldExampleVC : UITableViewDataSource {
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
        return 4
    }
}

// MARK: Auto Complete Text View Delegate
//       Must be implemented for auto completion
extension AutoCompleteTextFieldExampleVC : WAutoCompleteTextViewDelegate {
    public func didChangeAutoCompletionPrefix(prefix: String, word: String) {
        searchResults.removeAll()
        
        // For the example, just show options of whatever the user typed with 1-4 appended to end
        for i in 1...4 {
            searchResults.append(word.stringByAppendingString(String(i)))
        }
    }
    
    public func didSelectAutoCompletion(word: String) {
        // Word was chosen, called after word has been replaced
    }
}