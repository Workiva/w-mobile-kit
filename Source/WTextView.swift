//
//  WTextView.swift
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

import Foundation
import SnapKit

let KEY_RANGE_TOTAL = "TotalRange"
let KEY_RANGE_LINK = "LinkRange"
let KEY_RANGE_ADDRESS = "AddressRange"

public protocol WTextViewDelegate: UITextViewDelegate {
    func textViewShouldReturn(_ textView: WTextView) -> Bool
}

open class WTextView: UITextView, UITextViewDelegate {
    let leftImageView: UIImageView = UIImageView()
    let placeholderLabel: UILabel = UILabel()
    let testLabel: UILabel = UILabel()

    open weak var wTextViewDelegate: WTextViewDelegate?

    override open var text: String! {
        didSet {
            textDidChange()
        }
    }

    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
        
    open var placeholderText: String = "" {
        didSet {
            placeholderLabel.text = placeholderText
            textDidChange()
        }
    }
    
    open var placeholderTextColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
            textDidChange()
        }
    }
    
    open var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
            updateUI()
        }
    }
    
    override open var font: UIFont? {
        didSet {
            placeholderLabel.font = font
            textDidChange()
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
            textDidChange()
        }
    }

    open var verticalOffsetForLeftImage: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }

    open var leftPaddingForLeftImage: CGFloat = 4 {
        didSet {
            updateUI()
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
        self.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateUI()
    }

    open override func becomeFirstResponder() -> Bool {
        let returnValue = super.becomeFirstResponder()

        updateUI()

        return returnValue
    }
    
    open func commonInit() {
        isEditable = false
        isScrollEnabled = false
        delegate = self
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name: NSNotification.Name.UITextViewTextDidChange,
                                                         object: nil)

        addSubview(leftImageView)
        addSubview(placeholderLabel)

        // This is a workaround to get the default font set on the text view
        //  the property is explicitly unwrapped but nil during initialization until text is set
        let oldText = text
        text = "a"
        text = oldText

        placeholderLabel.text = placeholderText
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.isHidden = !text.isEmpty
    }

    @objc fileprivate func textDidChange() {
        updateUI()
    }
    
    fileprivate func updateUI() {
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.isHidden = !text.isEmpty

        if (self.superview != nil) {
            let imageWidthHeight = 20

            let leftInset: CGFloat = leftImageView.image != nil ? CGFloat(imageWidthHeight) + leftPaddingForLeftImage - 2 : 0
            let leftPlaceholderOffset = 5 + leftInset

            textContainerInset = UIEdgeInsets(top: 8, left: leftInset, bottom: 8, right: 0)

            leftImageView.snp.remakeConstraints() { (make) in
                make.centerY.equalTo(self).offset(verticalOffsetForLeftImage)
                make.left.equalTo(self).offset(leftPaddingForLeftImage)
                make.width.equalTo(imageWidthHeight)
                make.height.equalTo(imageWidthHeight)
            }

            placeholderLabel.snp.remakeConstraints() { (make) in
                make.centerY.equalTo(self).offset(0.5)
                make.width.equalTo(self).offset(-leftPlaceholderOffset - 5).priority(750)
                make.left.equalTo(self).offset(leftPlaceholderOffset)
                make.height.equalTo(self)
            }

            layoutIfNeeded()
        }
    }

    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let delegate = wTextViewDelegate , text == "\n" {
            return delegate.textViewShouldReturn(self)
        }
        return true
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
}

open class WMarkdownTextView: WTextView {
    override open var text: String! {
        didSet {
            textDidChange()
            buildTextView(text)
        }
    }
    
    public convenience init(_ text: String) {
        self.init(frame: CGRect.zero)
                
        commonInit()
        buildTextView(text)
    }
    
    open func buildTextView(_ text: String) {
        let attribString = NSMutableAttributedString(string: text)
        
        if let markdownArray = rangeForMarkdownURL(text) {
            for markdownDict in markdownArray.reversed() {
                let totalRange = markdownDict[KEY_RANGE_TOTAL]
                let linkRange = markdownDict[KEY_RANGE_LINK]
                let addressRange = markdownDict[KEY_RANGE_ADDRESS]
                
                let linkString = text.substring(with: linkRange!)
                let addressString = text.substring(with: addressRange!)
                
                let startIndexDistance = text.characters.distance(from: text.startIndex, to: totalRange!.lowerBound)
                let replaceRange = NSMakeRange(startIndexDistance, text.characters.distance(from: text.startIndex, to: totalRange!.upperBound) - startIndexDistance)
                
                let replacedAttribString = NSMutableAttributedString(string: linkString)
                replacedAttribString.addAttribute(NSLinkAttributeName, value: addressString, range: NSMakeRange(0, linkString.characters.count))
                
                attribString.replaceCharacters(in: replaceRange, with: replacedAttribString)
            }
        }
        
        self.attributedText = attribString
    }
    
    open func rangeForMarkdownURL(_ text: String) -> Array<Dictionary<String, Range<String.Index>>>? {
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
        for (index, char) in text.characters.enumerated() {
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
                let totalRange = text.characters.index(text.startIndex, offsetBy: openBracketPos!)..<text.characters.index(text.startIndex, offsetBy: closeParenPos! + 1)
                let linkRange = text.characters.index(text.startIndex, offsetBy: openBracketPos! + 1)..<text.characters.index(text.startIndex, offsetBy: closeBracketPos!)
                let addressRange = text.characters.index(text.startIndex, offsetBy: openParenPos! + 1)..<text.characters.index(text.startIndex, offsetBy: closeParenPos!)
                
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
    
    open func textView(_ textView: UITextView, shouldInteractWithURL URL: Foundation.URL, inRange characterRange: NSRange) -> Bool {
        return true
    }    
}
