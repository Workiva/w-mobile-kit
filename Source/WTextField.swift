//
//  WTextField.swift
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

@objc public protocol WAutoCompleteTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField)
}

open class WTextField: UITextField {
    open var imageSquareSize: CGFloat = 16
    open var paddingBetweenTextAndImage: CGFloat = 8

    fileprivate var bottomLine = CALayer()
    open var bottomLineWidth: CGFloat = 1 {
        didSet {
            setBottomBorder()
        }
    }
    open var bottomLineWidthWithText: CGFloat = 2 {
        didSet {
            setBottomBorder()
        }
    }
    fileprivate var currentBottomLineWidth: CGFloat? // Used to preserve above set values
    
    open weak var autoCompleteDelegate: WAutoCompleteTextFieldDelegate?
        
    open override var selectedTextRange: UITextRange? {
        didSet {
            autoCompleteDelegate?.textFieldDidChangeSelection(self)
        }
    }

    open override var rightViewMode: UITextFieldViewMode {
        didSet {
            determineIfRightViewShouldBeHidden()
        }
    }

    open var bottomLineColor: UIColor = .white {
        didSet {
            setBottomBorder()
        }
    }

    open var clearPlacholderOnEditing: Bool = true

    open var placeHolderTextColor: UIColor = UIColor(hex: 0xFFFFFF, alpha: 0.55) {
        didSet {
            if (self.placeholder != nil) {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeHolderTextColor])
            } else {
                self.setEmptyPlaceholder()
            }
        }
    }

    open var leftImage: UIImage? {
        didSet {
            setupUI()
        }
    }

    open var rightImage: UIImage? {
        didSet {
            setupUI()
        }
    }

    open var rightViewIsClearButton: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
        textColor = .white
        tintColor = .white
        placeHolderTextColor = UIColor(hex: 0xFFFFFF, alpha: 0.55)
        backgroundColor = .clear
        autocapitalizationType = .none
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 9

        borderStyle = .none

        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    open func setupUI() {
        // Left View configuration
        if (leftImage != nil) {
            leftView = UIImageView(image: leftImage)
            leftView?.contentMode = .scaleAspectFit
            leftViewMode = .always
        }

        // Right View configuration
        if (rightImage != nil) {
            if (rightViewIsClearButton) {
                let clearButton = UIButton()
                clearButton.setImage(rightImage, for: UIControlState())
                clearButton.addTarget(self, action: #selector(clearButtonWasPressed), for: .touchUpInside)
                rightView = clearButton
                rightViewMode = .whileEditing
                rightView?.isHidden = true
            } else {
                rightView = UIImageView(image: rightImage)
                rightViewMode = .always
            }
            rightView?.contentMode = .scaleAspectFit
        }
    }

    open func setBottomBorder() {
        currentBottomLineWidth = (text == nil && text!.isEmpty) ? bottomLineWidth : bottomLineWidthWithText

        bottomLine.frame = CGRect(x: 0, y: frame.height - bottomLineWidth, width: frame.width, height: currentBottomLineWidth!)
        bottomLine.backgroundColor = bottomLineColor.cgColor

        // Only add the layer if it has not yet been added.
        if (bottomLine.superlayer != layer) {
            layer.addSublayer(bottomLine)
        }
    }

    fileprivate func setEmptyPlaceholder() {
        // We need to set the placeholder to an empty string in this case so that
        // the color persists when they "set" (now really change) the placeholder text
        self.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: placeHolderTextColor])
    }

    // MARK: - Custom Rect Sizings
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let originY = (bounds.size.height - imageSquareSize) / 2
        return CGRect(x: 0, y: originY, width: imageSquareSize, height: imageSquareSize)
    }

    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originY = (bounds.size.height - imageSquareSize) / 2
        return CGRect(x: bounds.size.width - imageSquareSize, y: originY, width: imageSquareSize, height: imageSquareSize)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        setBottomBorder()
        return wCustomTextRect(bounds)
    }

    fileprivate func wCustomTextRect(_ bounds: CGRect) -> CGRect {
        let imageWidthWithPadding: CGFloat = imageSquareSize + paddingBetweenTextAndImage
        var xPosition: CGFloat = bounds.origin.x
        var width = bounds.size.width

        if (leftView != nil) {
            xPosition += imageWidthWithPadding
            width -= imageWidthWithPadding
        }

        if (rightView != nil) {
            width -= imageWidthWithPadding
        }

        return CGRect(x: xPosition, y: bounds.origin.y, width: width, height: bounds.size.height - 2)
    }

    @objc func textFieldDidChange() {
        determineIfRightViewShouldBeHidden()
    }

    func determineIfRightViewShouldBeHidden() {
        if (rightViewIsClearButton) {
            switch rightViewMode {
            case .always:
                rightView?.isHidden = false
            case .never:
                rightView?.isHidden = true
            case .unlessEditing:
                rightView?.isHidden = !(text == nil || text!.isEmpty)
            case .whileEditing:
                rightView?.isHidden = (text == nil || text!.isEmpty)
            }
        }
    }

    @objc func clearButtonWasPressed() {
        text = ""
        sendActions(for: .editingChanged)
        determineIfRightViewShouldBeHidden()
    }
}
