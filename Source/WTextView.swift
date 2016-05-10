//
//  WTextView.swift
//  WMobileKit

import Foundation
import SnapKit

let KEY_RANGE_TOTAL = "TotalRange"
let KEY_RANGE_LINK = "LinkRange"
let KEY_RANGE_ADDRESS = "AddressRange"

public class WTextView: UITextView, UITextViewDelegate {
    public override var text: String! {
        didSet {
            buildTextView(text)
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
                break;
            case "]":
                if (foundURLString) {
                    resetVariables()
                    
                    break;
                }
                numOpeningBrackets -= 1
                if (numOpeningBrackets <= 0) {
                    closeBracketPos = index
                    foundURLString = true
                }
                break;
            case "(":
                if (!foundURLString) {
                    continue
                }
                if openParenPos != nil {
                    resetVariables()
                    
                    break;
                }
                openParenPos = index
                break;
            case ")":
                if (!foundURLString) {
                    continue
                }
                if (openParenPos == nil || closeParenPos != nil) {
                    resetVariables()
                    
                    break;
                }
                closeParenPos = index

                // Create ranges of form Range<String.Index>
                let totalRange = text.startIndex.advancedBy(openBracketPos!)..<text.startIndex.advancedBy(closeParenPos! + 1)
                let linkRange = text.startIndex.advancedBy(openBracketPos! + 1)..<text.startIndex.advancedBy(closeBracketPos!)
                let addressRange = text.startIndex.advancedBy(openParenPos! + 1)..<text.startIndex.advancedBy(closeParenPos!)
                    
                let markdownDict = [KEY_RANGE_TOTAL: totalRange, KEY_RANGE_LINK: linkRange, KEY_RANGE_ADDRESS: addressRange]
                markdownArray.append(markdownDict)
                
                resetVariables()
                
                break;
            case " ":
                break;
            default:
                if (openParenPos == nil && foundURLString) {
                    resetVariables()
                }
                break;
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
}
