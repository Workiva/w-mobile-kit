//
//  WAutoCompleteTextView.swift
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

import UIKit
import SnapKit

let TEXT_VIEW_HEIGHT: CGFloat = 48
let MAX_TEXT_VIEW_HEIGHT: CGFloat = TEXT_VIEW_HEIGHT * 4
let SUBMIT_BUTTON_WIDTH: CGFloat = 60

let TABLE_HEIGHT_MAX: CGFloat = 90
let TABLE_HEIGHT_ROW: CGFloat = 30

@objc public protocol WAutoCompletionTextViewDelegate: class {
    @objc optional func didSelectAutoCompletion(_ data: AnyObject)
}

@objc public protocol WAutoCompleteTextViewDataSource: UITableViewDataSource {
    @objc optional func didChangeAutoCompletionPrefix(_ textView: WAutoCompleteTextView, prefix: String, word: String)
    @objc optional func heightForAutoCompleteTable(_ textView: WAutoCompleteTextView) -> CGFloat
}

open class WAutoCompleteTextView: UIView {
    fileprivate var topLineSeparator = UIView()
    fileprivate var isAutoCompleting = false
    fileprivate var keyboardHeight: CGFloat?
    internal var backgroundView = UIView()
    internal var autoCompleteRange: Range<String.Index>?
    internal var currentTableHeight: CGFloat?

    open func isShowingAutoComplete() -> Bool {
        return isAutoCompleting
    }
    open var autoCompleteTable = WAutoCompleteTableView()
    open var textView = WTextView()
    open var replacesControlPrefix = false
    open var addSpaceAfterReplacement = true
    open var numCharactersBeforeAutoComplete = 1
    open var controlPrefix: String?
    open var bottomConstraintOffset: CGFloat = 0

    open lazy var submitButton = UIButton()
    open var hasSubmitButton: Bool = false {
        didSet {
            submitButton.isHidden = !hasSubmitButton
            setupUI()
        }
    }

    open weak var delegate: WAutoCompletionTextViewDelegate?
    open var dataSource: WAutoCompleteTextViewDataSource? {
        didSet {
            autoCompleteTable.dataSource = dataSource
        }
    }

    open var maxAutoCompleteHeight: CGFloat = TABLE_HEIGHT_MAX {
        didSet {
            setupUI()
        }
    }

    open var rowHeight: CGFloat = TABLE_HEIGHT_ROW {
        didSet {
            autoCompleteTable.rowHeight = rowHeight
            autoCompleteTable.reloadData()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupUI()
    }

    fileprivate func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(WAutoCompleteTextView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WAutoCompleteTextView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        backgroundColor = .clear

        addSubview(autoCompleteTable)
        autoCompleteTable.isScrollEnabled = true
        autoCompleteTable.delegate = self

        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor(hex: 0xEEEEEE)

        addSubview(textView)
        textView.backgroundColor = .white
        textView.isScrollEnabled = true
        textView.scrollsToTop = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.placeholderText = "Type @ to mention someone"
        textView.tintColor = UIColor(red: 0, green: 0.455, blue: 1.0, alpha: 1.0)
        textView.textColor = .darkGray
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.delegate = self

        addSubview(topLineSeparator)
        topLineSeparator.backgroundColor = .lightGray

        addSubview(submitButton)
        submitButton.setTitle("Submit", for: UIControlState())
        submitButton.setTitleColor(.darkGray, for: UIControlState())
        submitButton.titleLabel?.numberOfLines = 1
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        submitButton.backgroundColor = .clear
        submitButton.isHidden = true
        submitButton.isEnabled = false
    }

    open func setupUI() {
        if let superview = superview {
            autoCompleteTable.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(0)
                make.top.equalTo(self)
            }

            topLineSeparator.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.top.equalTo(autoCompleteTable.snp.bottom)
                make.height.equalTo(0.5)
            }

            backgroundView.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.top.equalTo(topLineSeparator.snp.bottom)
                make.height.equalTo(TEXT_VIEW_HEIGHT)
                make.bottom.equalTo(self)
            }

            if (hasSubmitButton) {
                submitButton.snp.remakeConstraints { (make) in
                    make.top.equalTo(backgroundView).offset(8)
                    make.right.equalTo(backgroundView).offset(-8)
                    make.width.equalTo(SUBMIT_BUTTON_WIDTH)
                    make.bottom.equalTo(backgroundView).offset(-8)
                }

                textView.snp.remakeConstraints { (make) in
                    make.left.equalTo(backgroundView).offset(8)
                    make.right.equalTo(submitButton.snp.left).offset(-8)
                    make.bottom.equalTo(backgroundView).offset(-8)
                    make.top.equalTo(backgroundView).offset(8)
                }
            } else {
                textView.snp.remakeConstraints { (make) in
                    make.left.equalTo(backgroundView).offset(8)
                    make.right.equalTo(backgroundView).offset(-8)
                    make.bottom.equalTo(backgroundView).offset(-8)
                    make.top.equalTo(backgroundView).offset(8)
                }
            }

            snp.remakeConstraints { (make) in
                make.left.equalTo(superview)
                make.right.equalTo(superview)
                if let keyboardHeight = keyboardHeight {
                    make.bottom.equalTo(superview).offset(-keyboardHeight)
                } else {
                    make.bottom.equalTo(superview).offset(-bottomConstraintOffset)
                }
            }
        }
    }

    open func dismiss() {
        animateTable(false)
        textView.text = nil
        textView.resignFirstResponder()
    }

    open func showAutoCompleteTable(_ show: Bool = true) {
        if (show) {
            autoCompleteTable.reloadData()
        }

        animateTable(show)
    }

    open func animateTable(_ animateIn: Bool = true) {
        var height = maxAutoCompleteHeight
        if let dataSourceHeight = dataSource?.heightForAutoCompleteTable?(self) {
            height = min(dataSourceHeight, maxAutoCompleteHeight)
        }

        if (currentTableHeight == height && animateIn) {
            return
        }
        currentTableHeight = animateIn ? height : 0

        isAutoCompleting = animateIn

        autoCompleteTable.snp.updateConstraints { (make) in
            if (animateIn) {
                make.height.equalTo(height)
            } else {
                make.height.equalTo(0)
            }
        }

        updateHeight()

        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.superview?.layoutIfNeeded()
        },
                       completion: { finished in
                        self.autoCompleteTable.isHidden = !animateIn
        }
        )
    }

    open func adjustForKeyboardHeight(_ height: CGFloat = 0) {
        if let currentSuperview = superview {
            snp.remakeConstraints { (make) in
                make.bottom.equalTo(currentSuperview).offset(-height)
                make.left.equalTo(currentSuperview)
                make.right.equalTo(currentSuperview)
            }

            updateHeight()
            currentSuperview.layoutIfNeeded()
        }
    }

    @objc open func keyboardWillShow(_ notification: Notification) {
        var height: CGFloat = bottomConstraintOffset
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] {
                let keyboardFrame = (keyboardInfo as AnyObject).cgRectValue
                let screenHeight = UIScreen.main.bounds.height

                height = screenHeight - (keyboardFrame?.origin.y)!
                keyboardHeight = height
            }
        }
        adjustForKeyboardHeight(height)
    }

    @objc open func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = nil
        adjustForKeyboardHeight(bottomConstraintOffset)
    }

    open func acceptAutoCompletionWithString(_ string: String) {
        acceptAutoCompletionWithAttributedString(NSAttributedString(string: string))
    }

    open func acceptAutoCompletionWithAttributedString(_ attributedString: NSAttributedString) {
        var replaceText = attributedString

        if let range = autoCompleteRange {
            var selection = textView.selectedTextRange

            if (addSpaceAfterReplacement) {
                if let mutableCopy = replaceText.mutableCopy() as? NSMutableAttributedString {
                    let attributedSuffix = NSMutableAttributedString(string: " ")

                    attributedSuffix.addAttribute(NSFontAttributeName,
                                                  value: textView.font!,
                                                  range: NSRange(location:0,
                                                                 length:attributedSuffix.length))

                    attributedSuffix.addAttribute(NSForegroundColorAttributeName,
                                                  value: textView.textColor!,
                                                  range: NSRange(location:0,
                                                                 length:attributedSuffix.length))

                    mutableCopy.append(attributedSuffix)

                    replaceText = mutableCopy
                }
            }

            if let currentText = textView.text {
                let location = currentText.distance(from: currentText.startIndex, to: range.lowerBound)
                let length = currentText.distance(from: range.lowerBound, to: range.upperBound)
                let ns = NSMakeRange(location, length)

                if let mutableCopy = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
                    mutableCopy.replaceCharacters(in: ns, with: replaceText)

                    textView.attributedText = mutableCopy

                    let autoCompleteOffset = textView.text!.characters.distance(from: textView.text!.startIndex, to: range.lowerBound) + 1

                    if let newSelectPos = textView.position(from: textView.beginningOfDocument, offset: autoCompleteOffset + replaceText.length) {
                        selection = textView.textRange(from: newSelectPos, to: newSelectPos)
                        textView.selectedTextRange = selection
                    }
                }
            }
        } else {
            if (addSpaceAfterReplacement) {
                if let mutableCopy = replaceText.mutableCopy() as? NSMutableAttributedString {
                    let attributedSuffix = NSMutableAttributedString(string: " ")

                    attributedSuffix.addAttribute(NSFontAttributeName,
                        value: textView.font!,
                        range: NSRange(location:0,
                            length:attributedSuffix.length))

                    attributedSuffix.addAttribute(NSForegroundColorAttributeName,
                        value: textView.textColor!,
                        range: NSRange(location:0,
                            length:attributedSuffix.length))

                    mutableCopy.append(attributedSuffix)

                    replaceText = mutableCopy
                }
            }

            if let mutableCopy = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
                mutableCopy.append(replaceText)
                textView.attributedText = mutableCopy
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WAutoCompleteTextView: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            acceptAutoCompletionWithString(cell.textLabel!.text!)
            delegate?.didSelectAutoCompletion?(cell.textLabel!.text! as AnyObject)
        }

        showAutoCompleteTable(false)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WAutoCompleteTextView: UITextViewDelegate {
    open func textViewDidChange(_ textView: UITextView) {
        processWordAtCursor(textView)

        updateHeight()

        if (hasSubmitButton) {
            let trimmedString = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            submitButton.isEnabled = trimmedString.characters.count > 0
        }
    }

    open func textViewDidEndEditing(_ textView: UITextView) {
        showAutoCompleteTable(false)
    }

    fileprivate func updateHeight() {
        if (superview != nil) {
            if (textView.contentSize.height > 0) {
                var height = min(textView.contentSize.height, MAX_TEXT_VIEW_HEIGHT)
                height = max(height, TEXT_VIEW_HEIGHT)

                backgroundView.snp.updateConstraints { (make) in
                    make.height.equalTo(height)
                }

                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.superview?.layoutIfNeeded()
                },
                               completion: nil)
            }
        }
    }

    open func wordRangeAtCursor(_ textView: UITextView) -> Range<String.Index>? {
        var wordRange: Range<String.Index>?

        if let text = textView.text, text.characters.count > 0, let selectedRange = textView.selectedTextRange {
            let cursorPosition = min(textView.offset(from: textView.beginningOfDocument, to: selectedRange.start), text.characters.count)
            let cursorIndex = text.index(text.startIndex, offsetBy: cursorPosition)

            let leftOfCursorString = text.substring(to: cursorIndex)
            let leftComponents = leftOfCursorString.components(separatedBy: .whitespacesAndNewlines)
            let leftWordPart = leftComponents.last

            let rightOfCursorString = text.substring(from: cursorIndex)
            let rightComponents = rightOfCursorString.components(separatedBy: .whitespacesAndNewlines)
            let rightWordPart = rightComponents.first

            if (leftWordPart?.characters.count == 0 && rightWordPart?.characters.count == 0) {
                return nil
            }

            let leftOffset = -1 * (leftWordPart?.characters.count ?? 0)
            let rightOffset = rightWordPart?.characters.count ?? 0

            wordRange = text.index(cursorIndex, offsetBy: leftOffset)..<text.index(cursorIndex, offsetBy: rightOffset)
        }

        return wordRange
    }

    open func processWordAtCursor(_ textView: UITextView) {
        if let text = textView.text {
            if let range = wordRangeAtCursor(textView) {
                if let word = textView.text?.substring(with: range) {
                    if let prefix = controlPrefix {
                        if ((word.hasPrefix(prefix) && word.characters.count >= numCharactersBeforeAutoComplete + prefix.characters.count) || prefix.isEmpty) {
                            let offset = text.characters.distance(from: text.startIndex, to: range.lowerBound)
                            let pos = textView.position(from: textView.beginningOfDocument, offset: offset)
                            let wordWithoutPrefix = word.substring(from: word.characters.index(word.startIndex, offsetBy: prefix.characters.count))
                            if (textView.offset(from: textView.selectedTextRange!.start, to: pos!) != 0) {
                                if (!replacesControlPrefix) {
                                    autoCompleteRange = text.index(range.lowerBound, offsetBy: 1)..<range.upperBound
                                } else {
                                    autoCompleteRange = range
                                }

                                dataSource?.didChangeAutoCompletionPrefix?(self, prefix: prefix, word: wordWithoutPrefix)
                                return
                            }
                        }
                    }
                }
            }
            if (isAutoCompleting) {
                showAutoCompleteTable(false)
                autoCompleteRange = nil
            }
        }
    }

    open func textViewDidChangeSelection(_ textView: UITextView) {
        processWordAtCursor(textView)
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let delegate = (textView as? WTextView)?.wTextViewDelegate , text == "\n" {
            return delegate.textViewShouldReturn(textView as! WTextView)
        }
        return true
    }
}

open class WAutoCompleteTableView: UITableView {
    public convenience init() {
        self.init(frame: CGRect.zero, style: .plain)
        
        allowsSelection = true
        allowsSelectionDuringEditing = true
        isUserInteractionEnabled = true
        isScrollEnabled = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
