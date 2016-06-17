//
//  WTextView.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
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
import SnapKit

let KEY_RANGE_TOTAL = "TotalRange"
let KEY_RANGE_LINK = "LinkRange"
let KEY_RANGE_ADDRESS = "AddressRange"

public class WTextView: UITextView, UITextViewDelegate {
    private let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
        
    public var placeholderText: String = "" {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    public var placeholderTextColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    override public var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
                
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
    }
    
    public convenience init(_ text: String) {
        self.init(frame: CGRectZero)
        
        commonInit()
        
        buildTextView(text)
    }
    
    public func commonInit() {
        editable = false
        scrollEnabled = false
        delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name: UITextViewTextDidChangeNotification,
                                                         object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholderText
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.sizeToFit()
    }
        
    @objc private func textDidChange() {
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if (text.isEmpty) {
            addSubview(placeholderLabel)
            placeholderLabel.snp_remakeConstraints() { (make) in
                make.top.equalTo(self).offset(8)
                make.left.equalTo(self).offset(8)
                make.right.equalTo(self).offset(-8)
            }
        } else if (placeholderLabel.superview != nil){
            placeholderLabel.removeFromSuperview()
        }
    }
    
    public func buildTextView(text: String) {
        let attribString = NSMutableAttributedString(string: text)
        
        if let markdownArray = rangeForMarkdownURL(text) {
            for markdownDict in markdownArray.reverse() {
                let totalRange = markdownDict[KEY_RANGE_TOTAL]
                let linkRange = markdownDict[KEY_RANGE_LINK]
                let addressRange = markdownDict[KEY_RANGE_ADDRESS]
                
                let linkString = text.substringWithRange(linkRange!)
                let addressString = text.substringWithRange(addressRange!)
                
                let startIndexDistance = text.startIndex.distanceTo(totalRange!.startIndex)
                let replaceRange = NSMakeRange(startIndexDistance, text.startIndex.distanceTo(totalRange!.endIndex) - startIndexDistance)
                
                let replacedAttribString = NSMutableAttributedString(string: linkString)
                replacedAttribString.addAttribute(NSLinkAttributeName, value: addressString, range: NSMakeRange(0, linkString.characters.count))
                
                attribString.replaceCharactersInRange(replaceRange, withAttributedString: replacedAttribString)
            }
        }
        
        self.attributedText = attribString
    }
    
    public func rangeForMarkdownURL(text: String) -> Array<Dictionary<String, Range<String.Index>>>? {
        var numOpeningBrackets = 0
        var openBracketPos, closeBracketPos, openParenPos, closeParenPos: Int?
        var foundURLString = false
        
        var markdownArray = [Dictionary<String, Range<String.Index>>]()
        
        let resetVariables: (Void) -> Void = {
            openBracketPos = nil
            closeBracketPos = nil
            openParenPos = nil
            closeParenPos = nil
            numOpeningBrackets = 0
            foundURLString = false
        }
        
        // find end of url string
        for (index, char) in text.characters.enumerate() {
            switch char {
            case "[":
                if (foundURLString) {
                    continue
                }
                if (numOpeningBrackets == 0) {
                    openBracketPos = index
                }
                numOpeningBrackets += 1
            case "]":
                if (foundURLString) {
                    resetVariables()
                    break
                }
                numOpeningBrackets -= 1
                if (numOpeningBrackets <= 0) {
                    closeBracketPos = index
                    foundURLString = true
                }
            case "(":
                if (!foundURLString) {
                    continue
                }
                if openParenPos != nil {
                    resetVariables()
                    break
                }
                openParenPos = index
            case ")":
                if (!foundURLString) {
                    continue
                }
                if (openParenPos == nil || closeParenPos != nil) {
                    resetVariables()
                    break
                }
                closeParenPos = index

                // Create ranges of form Range<String.Index>
                let totalRange = text.startIndex.advancedBy(openBracketPos!)..<text.startIndex.advancedBy(closeParenPos! + 1)
                let linkRange = text.startIndex.advancedBy(openBracketPos! + 1)..<text.startIndex.advancedBy(closeBracketPos!)
                let addressRange = text.startIndex.advancedBy(openParenPos! + 1)..<text.startIndex.advancedBy(closeParenPos!)
                    
                let markdownDict = [KEY_RANGE_TOTAL: totalRange, KEY_RANGE_LINK: linkRange, KEY_RANGE_ADDRESS: addressRange]
                markdownArray.append(markdownDict)
                
                resetVariables()
            case " ":
                break;
            default:
                if (openParenPos == nil && foundURLString) {
                    resetVariables()
                }
            }
        }
        
        if (markdownArray.count > 0) {
            return markdownArray
        }
        
        return nil
    }
                
    public func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UITextViewTextDidChangeNotification,
                                                            object: nil)
    }    
}
