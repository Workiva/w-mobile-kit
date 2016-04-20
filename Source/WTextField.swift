//
//  WTextField.swift
//  WMobileKit

import UIKit

public class WTextField: UITextField {
    public var imageSquareSize: CGFloat = 16
    public var paddingBetweenTextAndImage: CGFloat = 8

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
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public func commonInit() {
        textColor = .whiteColor()
        tintColor = .whiteColor()
        backgroundColor = .clearColor()
        autocapitalizationType = .None

        borderStyle = .None
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
            rightView = UIImageView(image: rightImage)
            rightView?.contentMode = .ScaleAspectFit
            rightViewMode = .Always
        }
    }

    public func setBottomBorder(color: UIColor, width: CGFloat) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0, frame.height - width, frame.width, width)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor

        layer.addSublayer(bottomLine)
    }

    // MARK - Rect calculations
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        setBottomBorder(.whiteColor(), width: 1)
    }

    public override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        let originY = (frame.height - imageSquareSize) / 2
        return CGRectMake(0, originY, imageSquareSize, imageSquareSize)
    }

    public override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        let originY = (frame.height - imageSquareSize) / 2
        return CGRectMake(frame.width - imageSquareSize, originY, imageSquareSize, imageSquareSize)
    }

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return wCustomTextRect(bounds)
    }

    public override func textRectForBounds(bounds: CGRect) -> CGRect {
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

        return CGRectMake(xPosition, bounds.origin.y, width, bounds.size.height)
    }
}