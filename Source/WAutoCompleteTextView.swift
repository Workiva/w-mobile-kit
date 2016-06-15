//
//  WAutoCompleteTextView.swift
//  WMobileKit

import UIKit
import SnapKit

let TEXT_VIEW_HEIGHT: CGFloat = 48
let SUBMIT_BUTTON_WIDTH: CGFloat = 60
let TABLE_HEIGHT_MAX: CGFloat = 90
let TABLE_HEIGHT_ROW: CGFloat = 30

@objc public protocol WAutoCompletionTextViewDelegate : class {
    optional func didSelectAutoCompletion(data: AnyObject)
}

@objc public protocol WAutoCompleteTextViewDataSource : UITableViewDataSource {
    optional func didChangeAutoCompletionPrefix(textView: WAutoCompleteTextView, prefix: String, word: String)
    optional func heightForAutoCompleteTable(textView: WAutoCompleteTextView) -> CGFloat
}

public class WAutoCompleteTextView : UIView {
    private var topLineSeparator = UIView()
    private var isAutoCompleting = false
    private var keyboardHeight: CGFloat?
    internal var backgroundView = UIView()
    internal var autoCompleteRange: Range<String.Index>?
    
    public func isShowingAutoComplete() -> Bool {
        return isAutoCompleting
    }
    public var autoCompleteTable = WAutoCompleteTableView()
    public var textView = WTextView()
    public var replacesControlPrefix = false
    public var addSpaceAfterReplacement = true
    public var numCharactersBeforeAutoComplete = 1
    public var controlPrefix: String?
    public var bottomConstraintOffset: CGFloat = 0
    
    public lazy var submitButton = UIButton()
    public var hasSubmitButton: Bool = false {
        didSet {
            submitButton.hidden = !hasSubmitButton
            setupUI()
        }
    }
    
    public weak var delegate: WAutoCompletionTextViewDelegate?
    public weak var dataSource: WAutoCompleteTextViewDataSource? {
        didSet {
            autoCompleteTable.dataSource = dataSource
        }
    }
    
    public var maxAutoCompleteHeight: CGFloat = TABLE_HEIGHT_MAX {
        didSet {
            if (!CGRectEqualToRect(bounds, CGRectZero)) {
                setupUI()
            }
        }
    }
    
    public var rowHeight: CGFloat = TABLE_HEIGHT_ROW {
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
        self.init(frame: CGRectZero)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WAutoCompleteTextView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WAutoCompleteTextView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        backgroundColor = .clearColor()
        
        addSubview(autoCompleteTable)
        autoCompleteTable.hidden = true
        autoCompleteTable.scrollEnabled = true
        autoCompleteTable.delegate = self
        
        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor(hex: 0xEEEEEE)
        
        addSubview(textView)
        textView.backgroundColor = .whiteColor()
        textView.scrollEnabled = false
        textView.editable = true
        textView.userInteractionEnabled = true
        textView.font = UIFont.systemFontOfSize(15)
        textView.placeholderText = "Type @ to mention someone"
        textView.tintColor = UIColor(colorLiteralRed: 0, green: 0.455, blue: 1, alpha: 1)
        textView.textColor = .darkGrayColor()
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textView.delegate = self
        
        addSubview(topLineSeparator)
        topLineSeparator.backgroundColor = .lightGrayColor()
        
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.setTitleColor(.darkGrayColor(), forState: .Normal)
        submitButton.titleLabel?.numberOfLines = 1
        submitButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        submitButton.backgroundColor = .clearColor()
        submitButton.hidden = true
        addSubview(submitButton)
    }
    
    public func setupUI() {
        backgroundView.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(TEXT_VIEW_HEIGHT)
            make.bottom.equalTo(self)
        }
        
        if (hasSubmitButton) {
            submitButton.snp_remakeConstraints { (make) in
                make.top.equalTo(backgroundView).offset(8)
                make.right.equalTo(backgroundView).offset(-8)
                make.width.equalTo(SUBMIT_BUTTON_WIDTH)
                make.bottom.equalTo(backgroundView).offset(-8)
            }
            
            textView.snp_remakeConstraints { (make) in
                make.left.equalTo(backgroundView).offset(8)
                make.right.equalTo(submitButton.snp_left).offset(-8)
                make.bottom.equalTo(backgroundView).offset(-8)
                make.top.equalTo(backgroundView).offset(8)
            }
        } else {
            textView.snp_remakeConstraints { (make) in
                make.left.equalTo(backgroundView).offset(8)
                make.right.equalTo(backgroundView).offset(-8)
                make.bottom.equalTo(backgroundView).offset(-8)
                make.top.equalTo(backgroundView).offset(8)
            }
        }
        topLineSeparator.snp_remakeConstraints { (make) in
            make.left.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
            make.top.equalTo(backgroundView)
            make.height.equalTo(0.5)
        }
        autoCompleteTable.snp_remakeConstraints { (make) in
            make.left.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
            make.height.equalTo(0)
            make.top.equalTo(backgroundView)
        }
        
        if let superview = superview {
            snp_remakeConstraints { (make) in
                make.left.equalTo(superview)
                make.right.equalTo(superview)
                if let keyboardHeight = keyboardHeight {
                    make.bottom.equalTo(superview).offset(-keyboardHeight)
                } else {
                    make.bottom.equalTo(superview).offset(-bottomConstraintOffset)
                }
                make.height.equalTo(TEXT_VIEW_HEIGHT)
            }
            
            superview.layoutIfNeeded()
        } else {
            layoutIfNeeded()
        }
    }
    
    public func showAutoCompleteView(show: Bool = true) {
        animateTable(show)
        isAutoCompleting = show
        autoCompleteTable.reloadData()
    }
    
    public func animateTable(animateIn: Bool = true) {
        autoCompleteTable.hidden = false
        
        var height = maxAutoCompleteHeight
        if let dataSourceHeight = dataSource?.heightForAutoCompleteTable?(self) {
            height = min(dataSourceHeight, maxAutoCompleteHeight)
        }
        autoCompleteTable.snp_remakeConstraints { (make) in
            make.left.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
            make.bottom.equalTo(backgroundView.snp_top)
            if (animateIn) {
                make.height.equalTo(height)
            } else {
                make.height.equalTo(0)
            }
        }
        
        var viewToLayout: UIView = self
        if let superview = superview {
            snp_remakeConstraints { (make) in
                make.left.equalTo(superview)
                make.right.equalTo(superview)
                if let keyboardHeight = keyboardHeight {
                    make.bottom.equalTo(superview).offset(-keyboardHeight)
                } else {
                    make.bottom.equalTo(superview).offset(-bottomConstraintOffset)
                }
                if (animateIn) {
                    make.height.equalTo(TEXT_VIEW_HEIGHT + height)
                } else {
                    make.height.equalTo(TEXT_VIEW_HEIGHT)
                }
            }
            
            viewToLayout = superview
        }
        
        UIView.animateWithDuration(0.3,
            animations: {
                viewToLayout.layoutIfNeeded()
            },
            completion: { finished in
                if (!animateIn) {
                    self.autoCompleteTable.hidden = true
                }
            }
        )
    }
    
    public func adjustForKeyboardHeight(height: CGFloat = 0) {
        if let currentSuperview = superview {
            var tableHeight: CGFloat = 0
            if let dataSourceHeight = dataSource?.heightForAutoCompleteTable?(self) {
                tableHeight = dataSourceHeight
            }
            snp_remakeConstraints { (make) in
                make.bottom.equalTo(currentSuperview).offset(-height)
                make.left.equalTo(currentSuperview)
                make.right.equalTo(currentSuperview)
                if (isAutoCompleting) {
                    make.height.equalTo(TEXT_VIEW_HEIGHT + tableHeight)
                } else {
                    make.height.equalTo(TEXT_VIEW_HEIGHT)
                }
            }
            
            currentSuperview.layoutIfNeeded()
        }
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        var height: CGFloat = bottomConstraintOffset
        if let userInfo = notification.userInfo {
            if let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] {
                let keyboardFrame = keyboardInfo.CGRectValue()
                let screenHeight = UIScreen.mainScreen().bounds.height
                
                height = screenHeight - keyboardFrame.origin.y
                keyboardHeight = height
            }
        }
        adjustForKeyboardHeight(height)
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = nil
        adjustForKeyboardHeight(bottomConstraintOffset)
    }
    
    public func acceptAutoCompletionWithString(string: String) {
        if let range = autoCompleteRange {
            var selection = textView.selectedTextRange
            
            if (!replacesControlPrefix) {
                autoCompleteRange = range.startIndex.advancedBy(1)..<range.endIndex
            }
            
            var replaceText = string
            if (addSpaceAfterReplacement) {
                replaceText = replaceText.stringByAppendingString(" ")
            }
            textView.text?.replaceRange(autoCompleteRange!, with: replaceText)
            
            let autoCompleteOffset = textView.text!.startIndex.distanceTo(range.startIndex) + 1
            
            if let newSelectPos = textView.positionFromPosition(textView.beginningOfDocument, offset: autoCompleteOffset + replaceText.characters.count) {
                selection = textView.textRangeFromPosition(newSelectPos, toPosition: newSelectPos)
                textView.selectedTextRange = selection
            }
        } else {
            textView.text = textView.text.stringByAppendingString(string)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension WAutoCompleteTextView : UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            acceptAutoCompletionWithString(cell.textLabel!.text!)
            delegate?.didSelectAutoCompletion?(cell.textLabel!.text!)
        }
        
        showAutoCompleteView(false)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension WAutoCompleteTextView : UITextViewDelegate {
    public func textViewDidChange(textView: UITextView) {
        processWordAtCursor(textView)
        
        textView.bounds.size = textView.contentSize
        textView.layoutIfNeeded()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        showAutoCompleteView(false)
    }
    
    public func wordRangeAtCursor(textView: UITextView) -> Range<String.Index>? {
        if (textView.text!.characters.count <= 0) {
            return nil
        }
        
        if let range = textView.selectedTextRange {
            let firstPos = min(textView.offsetFromPosition(textView.beginningOfDocument, toPosition: range.start), textView.text!.characters.count)
            let firstIndex = textView.text!.characters.startIndex.advancedBy(firstPos)
            
            let leftPortion = textView.text?.substringToIndex(firstIndex)
            let leftComponents = leftPortion?.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let leftWordPart = leftComponents?.last
            
            let rightPortion = textView.text?.substringFromIndex(firstIndex)
            let rightComponents = rightPortion?.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let rightWordPart = rightComponents?.first
            
            if (leftWordPart?.characters.count == 0 && rightWordPart?.characters.count == 0) {
                return nil
            }
            
            if (firstPos > 0) {
                let charBeforeCursor = textView.text?.substringWithRange(textView.text!.startIndex.advancedBy(firstPos - 1)..<textView.text!.startIndex.advancedBy(firstPos))
                let whitespaceRange = charBeforeCursor?.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
                
                if (whitespaceRange?.count == 1) {
                    return firstIndex.advancedBy(-leftWordPart!.characters.count)..<firstIndex.advancedBy(rightWordPart!.characters.count)
                }
            }
            
            return firstIndex.advancedBy(-leftWordPart!.characters.count)..<firstIndex.advancedBy(rightWordPart!.characters.count)
        }
        return nil
    }
    
    public func processWordAtCursor(textView: UITextView) {
        if let text = textView.text {
            if let range = wordRangeAtCursor(textView) {
                if let word = textView.text?.substringWithRange(range) {
                    if let prefix = controlPrefix {
                        if ((word.hasPrefix(prefix) && word.characters.count >= numCharactersBeforeAutoComplete + prefix.characters.count) || prefix.isEmpty) {
                            let offset = textView.text!.startIndex.distanceTo(range.startIndex)
                            let pos = textView.positionFromPosition(textView.beginningOfDocument, offset: offset)
                            let wordWithoutPrefix = word.substringFromIndex(word.startIndex.advancedBy(prefix.characters.count))
                            if (textView.offsetFromPosition(textView.selectedTextRange!.start, toPosition: pos!) != 0) {
                                showAutoCompleteView(true)
                                autoCompleteRange = range
                                
                                dataSource?.didChangeAutoCompletionPrefix?(self, prefix: prefix, word: wordWithoutPrefix)
                                
                                return
                            }
                        }
                    }
                }
            }
            if (isAutoCompleting) {
                showAutoCompleteView(false)
                autoCompleteRange = nil
            }
        }
    }
    
    public func textViewDidChangeSelection(textView: UITextView) {
        processWordAtCursor(textView)
        
        if (hasSubmitButton) {
            let trimmedString = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            submitButton.enabled = trimmedString.characters.count > 0
        }
    }
}

public class WAutoCompleteTableView : UITableView {
    public convenience init() {
        self.init(frame: CGRectZero, style: .Plain)
        
        allowsSelection = true
        allowsSelectionDuringEditing = true
        userInteractionEnabled = true
        scrollEnabled = true
    }
}