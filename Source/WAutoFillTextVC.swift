//
//  WAutoFillTextVC.swift
//  WMobileKit

import Foundation

let TEXT_VIEW_HEIGHT = 48

public class WAutoFillTextView : UIView {
    private var topLineSeparator = UIView()
    
    public var textField = WTextField()
    
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
        
        addSubview(textField)
        backgroundColor = .lightGrayColor()
        textField.backgroundColor = .whiteColor()
        textField.borderStyle = .RoundedRect
        textField.bottomLineColor = .clearColor()
        textField.placeholder = "  Type @ to mention someone"
        textField.tintColor = nil
        textField.textColor = .blackColor()
        
        addSubview(topLineSeparator)
        topLineSeparator.backgroundColor = .darkGrayColor()
    }
    
    public func setupUI(animated: Bool = false, height: CGFloat = 0) {
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
        
        layoutIfNeeded()
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