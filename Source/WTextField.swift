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
    func textFieldDidChangeSelection(textField: UITextField)
}

public class WTextField: UITextField {
    public var imageSquareSize: CGFloat = 16
    public var paddingBetweenTextAndImage: CGFloat = 8

    private var bottomLine = CALayer()
    public var bottomLineWidth: CGFloat = 1 {
        didSet {
            setBottomBorder()
        }
    }
    public var bottomLineWidthWithText: CGFloat = 2 {
        didSet {
            setBottomBorder()
        }
    }
    private var currentBottomLineWidth: CGFloat? // Used to preserve above set values
    
    public weak var autoCompleteDelegate: WAutoCompleteTextFieldDelegate?
        
    public override var selectedTextRange: UITextRange? {
        didSet {
            autoCompleteDelegate?.textFieldDidChangeSelection(self)
        }
    }

    public override var rightViewMode: UITextFieldViewMode {
        didSet {
            determineIfRightViewShouldBeHidden()
        }
    }

    public var bottomLineColor: UIColor = .whiteColor() {
        didSet {
            setBottomBorder()
        }
    }

    public var clearPlacholderOnEditing: Bool = true

    public var placeHolderTextColor: UIColor = UIColor(hex: 0xFFFFFF, alpha: 0.55) {
        didSet {
            if (self.placeholder != nil) {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: placeHolderTextColor])
            } else {
                self.setEmptyPlaceholder()
            }
        }
    }

    public var leftImage: UIImage? {
        didSet {
            setupUI()
        }
    }

    public var rightImage: UIImage? {
        didSet {
            setupUI()
        }
    }

    public var rightViewIsClearButton: Bool = false {
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
        self.init(frame: CGRectZero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public func commonInit() {
        textColor = .whiteColor()
        tintColor = .whiteColor()
        placeHolderTextColor = UIColor(hex: 0xFFFFFF, alpha: 0.55)
        backgroundColor = .clearColor()
        autocapitalizationType = .None
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 9

        borderStyle = .None

        addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
    }

    public func setupUI() {
        // Left View configuration
        if (leftImage != nil) {
            leftView = UIImageView(image: leftImage)
            leftView?.contentMode = .ScaleAspectFit
            leftViewMode = .Always
        }

        // Right View configuration
        if (rightImage != nil) {
            if (rightViewIsClearButton) {
                let clearButton = UIButton()
                clearButton.setImage(rightImage, forState: .Normal)
                clearButton.addTarget(self, action: #selector(clearButtonWasPressed), forControlEvents: .TouchUpInside)
                rightView = clearButton
                rightViewMode = .WhileEditing
                rightView?.hidden = true
            } else {
                rightView = UIImageView(image: rightImage)
                rightViewMode = .Always
            }
            rightView?.contentMode = .ScaleAspectFit
        }
    }

    public func setBottomBorder() {
        currentBottomLineWidth = (text == nil && text!.isEmpty) ? bottomLineWidth : bottomLineWidthWithText

        bottomLine.frame = CGRectMake(0, frame.height - bottomLineWidth, frame.width, currentBottomLineWidth!)
        bottomLine.backgroundColor = bottomLineColor.CGColor

        // Only add the layer if it has not yet been added.
        if (bottomLine.superlayer != layer) {
            layer.addSublayer(bottomLine)
        }
    }

    private func setEmptyPlaceholder() {
        // We need to set the placeholder to an empty string in this case so that
        // the color persists when they "set" (now really change) the placeholder text
        self.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: placeHolderTextColor])
    }

    // MARK: - Custom Rect Sizings
    public override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        let originY = (bounds.size.height - imageSquareSize) / 2
        return CGRectMake(0, originY, imageSquareSize, imageSquareSize)
    }

    public override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        let originY = (bounds.size.height - imageSquareSize) / 2
        return CGRectMake(bounds.size.width - imageSquareSize, originY, imageSquareSize, imageSquareSize)
    }

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    public override func textRectForBounds(bounds: CGRect) -> CGRect {
        setBottomBorder()
        return wCustomTextRect(bounds)
    }

    private func wCustomTextRect(bounds: CGRect) -> CGRect {
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

        return CGRectMake(xPosition, bounds.origin.y, width, bounds.size.height - 2)
    }

    func textFieldDidChange() {
        determineIfRightViewShouldBeHidden()
    }

    func determineIfRightViewShouldBeHidden() {
        if (rightViewIsClearButton) {
            switch rightViewMode {
            case .Always:
                rightView?.hidden = false
            case .Never:
                rightView?.hidden = true
            case .UnlessEditing:
                rightView?.hidden = !(text == nil || text!.isEmpty)
            case .WhileEditing:
                rightView?.hidden = (text == nil || text!.isEmpty)
            }
        }
    }

    func clearButtonWasPressed() {
        text = ""
        sendActionsForControlEvents(.EditingChanged)
        determineIfRightViewShouldBeHidden()
    }
}
