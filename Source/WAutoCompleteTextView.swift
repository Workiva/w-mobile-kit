//
//  WAutoCompleteTextView.swift
//  WMobileKit

import UIKit

let TEXT_VIEW_HEIGHT: CGFloat = 48
let TABLE_HEIGHT_MAX: CGFloat = 90
let TABLE_HEIGHT_ROW: CGFloat = 30

@objc public protocol WAutoCompleteTextViewDelegate : class {
    optional func didChangeAutoCompletionPrefix(prefix: String, word: String)
    optional func didSelectAutoCompletion(word: String)
    optional func heightForAutoCompleteTable() -> CGFloat
}

public class WAutoCompleteTextView : UIView {
    private var topLineSeparator = UIView()
    private var backgroundView = UIView()
    private var isAutoCompleting = false
    internal var autoCompleteRange: Range<String.Index>?
    
    public var autoCompleteTable = WAutoCompleteTableView()
    public var textField = WTextField()
    public var replacesControlPrefix = false
    public var addSpaceAfterReplacement = true
    public var numCharactersBeforeAutoComplete = 1
    public var controlPrefix: String?
    public weak var delegate: WAutoCompleteTextViewDelegate?
    public weak var dataSource: UITableViewDataSource? {
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
    
    public override var bounds: CGRect {
        didSet {
            if (!CGRectEqualToRect(bounds, CGRectZero)) {
                setupUI()
            }
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
        
        if let newSuperview = superview {
            snp_remakeConstraints { (make) in
                make.left.equalTo(newSuperview)
                make.right.equalTo(newSuperview)
                make.bottom.equalTo(newSuperview)
                make.height.equalTo(TEXT_VIEW_HEIGHT)
            }
            newSuperview.layoutIfNeeded()
        }
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
        
        addSubview(textField)
        textField.backgroundColor = .whiteColor()
        textField.borderStyle = .None
        textField.bottomLineColor = .clearColor()
        textField.placeholder = "Type @ to mention someone"
        textField.tintColor = UIColor(colorLiteralRed: 0, green: 0.455, blue: 1, alpha: 1)
        textField.textColor = .darkGrayColor()
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.autoCompleteDelegate = self
        textField.addTarget(self, action: #selector(WAutoCompleteTextView.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        addSubview(topLineSeparator)
        topLineSeparator.backgroundColor = .lightGrayColor()
    }
    
    public func setupUI() {
        backgroundView.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(TEXT_VIEW_HEIGHT)
            make.bottom.equalTo(self)
        }
        textField.snp_remakeConstraints { (make) in
            make.left.equalTo(backgroundView).offset(8)
            make.right.equalTo(backgroundView).offset(-8)
            make.bottom.equalTo(backgroundView).offset(-8)
            make.top.equalTo(backgroundView).offset(8)
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
        UIView.performWithoutAnimation { 
            self.layoutIfNeeded()
        }
    }
    
    public func showAutoCompleteView(show: Bool = true) {
        animateTable(show)
        isAutoCompleting = show
        autoCompleteTable.reloadData()
    }
    
    public func animateTable(animateIn: Bool = true) {
        autoCompleteTable.hidden = false
        autoCompleteTable.snp_remakeConstraints { (make) in
            make.left.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
            make.bottom.equalTo(backgroundView.snp_top)
            if (animateIn) {
                if let setHeight = delegate?.heightForAutoCompleteTable?() {
                    make.height.equalTo(min(setHeight, maxAutoCompleteHeight))
                } else {
                    make.height.equalTo(maxAutoCompleteHeight)
                }
            } else {
                make.height.equalTo(0)
            }
        }
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.layoutIfNeeded()
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
            snp_remakeConstraints(closure: { (make) in
                make.bottom.equalTo(currentSuperview).offset(-height)
                make.left.equalTo(currentSuperview)
                make.right.equalTo(currentSuperview)
                make.height.equalTo(TEXT_VIEW_HEIGHT + maxAutoCompleteHeight)
            })
            
            currentSuperview.layoutIfNeeded()
        }
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        var height: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] {
                let keyboardHeight = keyboardInfo.CGRectValue().height
                height = keyboardHeight
            }
        }
        adjustForKeyboardHeight(height)
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboardHeight(0)
    }
    
    public func acceptAutoCompletionWithString(string: String) {
        if let range = autoCompleteRange {
            var selection = textField.selectedTextRange
            
            if (!replacesControlPrefix) {
                autoCompleteRange = range.startIndex.advancedBy(1)..<range.endIndex
            }
            
            var replaceText = string
            if (addSpaceAfterReplacement) {
                replaceText = replaceText.stringByAppendingString(" ")
            }
            textField.text?.replaceRange(autoCompleteRange!, with: replaceText)
            
            let autoCompleteOffset = textField.text!.startIndex.distanceTo(range.startIndex) + 1
            
            if let newSelectPos = textField.positionFromPosition(textField.beginningOfDocument, offset: autoCompleteOffset + replaceText.characters.count) {
                selection = textField.textRangeFromPosition(newSelectPos, toPosition: newSelectPos)
                textField.selectedTextRange = selection
            }
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

extension WAutoCompleteTextView : WAutoCompleteTextFieldDelegate {
    public func textFieldDidChange(textField: UITextField) {
        processWordAtCursor(textField)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        showAutoCompleteView(false)
    }
    
    public func wordRangeAtCursor(textField: UITextField) -> Range<String.Index>? {
        if (textField.text!.characters.count <= 0) {
            return nil
        }
        
        if let range = textField.selectedTextRange {
            let firstPos = min(textField.offsetFromPosition(textField.beginningOfDocument, toPosition: range.start), textField.text!.characters.count)
            let firstIndex = textField.text!.characters.startIndex.advancedBy(firstPos)
            
            let leftPortion = textField.text?.substringToIndex(firstIndex)
            let leftComponents = leftPortion?.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let leftWordPart = leftComponents?.last
            
            let rightPortion = textField.text?.substringFromIndex(firstIndex)
            let rightComponents = rightPortion?.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let rightWordPart = rightComponents?.first
            
            if (leftWordPart?.characters.count == 0 && rightWordPart?.characters.count == 0) {
                return nil
            }
            
            if (firstPos > 0) {
                let charBeforeCursor = textField.text?.substringWithRange(textField.text!.startIndex.advancedBy(firstPos - 1)..<textField.text!.startIndex.advancedBy(firstPos))
                let whitespaceRange = charBeforeCursor?.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
                
                if (whitespaceRange?.count == 1) {
                    return firstIndex.advancedBy(-leftWordPart!.characters.count)..<firstIndex.advancedBy(rightWordPart!.characters.count)
                }
            }
            
            return firstIndex.advancedBy(-leftWordPart!.characters.count)..<firstIndex.advancedBy(rightWordPart!.characters.count)
        }
        return nil
    }
    
    public func processWordAtCursor(textField: UITextField) {
        if let text = textField.text {
            if let range = wordRangeAtCursor(textField) {
                if let word = textField.text?.substringWithRange(range) {
                    if let prefix = controlPrefix {
                        if (word.hasPrefix(prefix) && word.characters.count >= numCharactersBeforeAutoComplete + prefix.characters.count) {
                            let offset = text.startIndex.distanceTo(range.startIndex)
                            let pos = textField.positionFromPosition(textField.beginningOfDocument, offset: offset)
                            let wordWithoutPrefix = word.substringFromIndex(word.startIndex.advancedBy(prefix.characters.count))
                            if (textField.offsetFromPosition(textField.selectedTextRange!.start, toPosition: pos!) != 0) {
                                showAutoCompleteView(true)
                                autoCompleteRange = range
                                
                                delegate?.didChangeAutoCompletionPrefix?(prefix, word: wordWithoutPrefix)
                                
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
    
    public func textFieldDidChangeSelection(textField: UITextField) {
        processWordAtCursor(textField)
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