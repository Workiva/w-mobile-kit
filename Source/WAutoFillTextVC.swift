//
//  WAutoFillTextVC.swift
//  WMobileKit

import Foundation

let TEXT_VIEW_HEIGHT = 48

public class WAutoFillTextView : UIView {
    private var topLineSeparator = UIView()
    private var backgroundView = UIView()
    private var autoCompleteTable = WAutoCompleteTableView()
    
    public var textField = WTextField()
    public var controlCharacter: Character?
    
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
        }
    }
    
    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WAutoFillTextView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WAutoFillTextView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        backgroundColor = .clearColor()
        
        addSubview(autoCompleteTable)
        autoCompleteTable.hidden = true
        autoCompleteTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        textField.delegate = self
        textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: .EditingChanged)
        
        addSubview(topLineSeparator)
        topLineSeparator.backgroundColor = .lightGrayColor()
    }
    
    public func setupUI(animated: Bool = false, height: CGFloat = 0) {
        backgroundView.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        textField.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(8)
        }
        topLineSeparator.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(0.5)
        }
        autoCompleteTable.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(40)
            make.top.equalTo(self)
        }
        layoutIfNeeded()
    }
    
    public func animateTableIn() {
        autoCompleteTable.hidden = false
        autoCompleteTable.snp_remakeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(40)
            make.bottom.equalTo(self.snp_top)
        }
        
        UIView.animateWithDuration(0.3) { 
            self.layoutIfNeeded()
        }
    }
    
    public func adjustForKeyboardHeight(height: CGFloat = 0) {
        if let superview = superview {
            snp_remakeConstraints(closure: { (make) in
                make.bottom.equalTo(superview).offset(-height)
                make.left.equalTo(superview)
                make.right.equalTo(superview)
                make.height.equalTo(TEXT_VIEW_HEIGHT)
            })
            
            superview.layoutIfNeeded()
        }
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let height = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        adjustForKeyboardHeight(height!)
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let height = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        adjustForKeyboardHeight(0)
    }
}

extension WAutoFillTextView : UITableViewDataSource {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("cell")!
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

extension WAutoFillTextView : UITextFieldDelegate {
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // do something
        return true
    }
    
    public func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            if let word = wordAtCursor(textField) {
                if (word.hasPrefix("@")) {
                    NSLog("We are changing mention word " + word)
                    animateTableIn()
                }
            }
        }
    }
    
    public func wordAtCursor(textField: UITextField) -> String? {
        if (textField.text!.characters.count <= 0) {
            return nil
        }
        
        if let range = textField.selectedTextRange {
            var firstPos = min(textField.offsetFromPosition(textField.beginningOfDocument, toPosition: range.start), textField.text!.characters.count)
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
                    return rightWordPart
                }
            }
            
            var word = leftWordPart?.stringByAppendingString(rightWordPart!)
            let linebreak = "\n"
            
            if (word?.rangeOfString(linebreak) != nil) {
                word = word?.componentsSeparatedByString(linebreak).last
            }
            return word
        }
        return nil
    }
}

public class WAutoCompleteTableView : UITableView {
    public convenience init() {
        self.init(frame: CGRectZero, style: .Plain)
    }
}