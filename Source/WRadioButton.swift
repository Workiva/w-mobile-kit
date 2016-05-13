//
//  WRadioButton.swift
//  WMobileKit

import Foundation
import UIKit
import SnapKit

public class WRadioButton: UIButton {

    // radio size
    // indicator size

    // text padding
    // button line width


    var iconSize: CGFloat = 30
    var iconColor: UIColor = UIColor.whiteColor()
    var iconStrokeWidth: CGFloat = 2.0
    var indicatorSize: CGFloat = 5.0
    var indicatorColor: UIColor = UIColor.blueColor()
    var marginWidth: CGFloat = 1.0
    var iconOnRight: Bool = false
    var iconSquare: Bool = false
    var multipleSelectionEnabled: Bool = false

    let kDefaulIconSize = 15.0;
    let kDefaultMarginWidth = 5.0
    let kGeneratedIconName = "Generated Icon"
    let groupModifing = false

    public var icon: UIImage? {
        didSet {
            setImage(icon, forState: UIControlState.Normal)
        }
    }

    public var iconSelected: UIImage? {
        didSet {
            setImage(iconSelected, forState: UIControlState.Selected)
            setImage(iconSelected, forState: UIControlState.Highlighted)
        }
    }

    internal func drawButton() {
        if icon != nil || icon?.accessibilityIdentifier == kGeneratedIconName {
            drawIconWithSelection(false)
        }

        if iconSelected != nil || iconSelected?.accessibilityIdentifier == kGeneratedIconName {
            drawIconWithSelection(true)
        }

        let marginWidth: CGFloat = self.marginWidth != 0 ? self.marginWidth : CGFloat(kDefaultMarginWidth)
        var isRightToLeftLayout = false

        if #available(iOS 9.0, *) {
            isRightToLeftLayout = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(semanticContentAttribute) == UIUserInterfaceLayoutDirection.RightToLeft
        } else {
            // Fallback on earlier versions
        }

        if iconOnRight {
            imageEdgeInsets = isRightToLeftLayout ?
                EdgeInsetsMake(0, left: 0, bottom: 0, right: self.frame.size.width - self.icon!.size.width) :
                EdgeInsetsMake(0, left:self.frame.size.width - self.icon!.size.width, bottom: 0, right: 0)
            titleEdgeInsets = isRightToLeftLayout ?
                EdgeInsetsMake(0, left: marginWidth + self.icon!.size.width, bottom: 0, right: -self.icon!.size.width) :
                EdgeInsetsMake(0, left: -self.icon!.size.width, bottom: 0, right: marginWidth + self.icon!.size.width)
        } else {
            if (isRightToLeftLayout) {
                imageEdgeInsets = EdgeInsetsMake(0, left: marginWidth, bottom: 0, right: 0)
            } else {
                titleEdgeInsets = EdgeInsetsMake(0, left: marginWidth, bottom: 0, right: 0)
            }
        }
    }
    //
    internal func drawIconWithSelection(selected: Bool) {
    }
    //        UIColor *defaulColor = selected ? [self titleColorForState:UIControlStateSelected | UIControlStateHighlighted] : [self titleColorForState:UIControlStateNormal];
    //        UIColor *iconColor = self.iconColor ? self.iconColor : defaulColor;
    //        UIColor *indicatorColor = self.indicatorColor ? self.indicatorColor : defaulColor;
    //        CGFloat iconSize = self.iconSize ? self.iconSize : kDefaulIconSize;
    //        CGFloat iconStrokeWidth = self.iconStrokeWidth ? self.iconStrokeWidth : iconSize / 9;
    //        CGFloat indicatorSize = self.indicatorSize ? self.indicatorSize : iconSize * 0.5;
    //
    //        CGRect rect = CGRectMake(0, 0, iconSize, iconSize);
    //        CGContextRef context = UIGraphicsGetCurrentContext();
    //        UIGraphicsPushContext(context);
    //        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    //
    //        // draw icon
    //        UIBezierPath* iconPath;
    //        CGRect iconRect = CGRectMake(iconStrokeWidth / 2, iconStrokeWidth / 2, iconSize - iconStrokeWidth, iconSize - iconStrokeWidth);
    //        if (self.isIconSquare) {
    //            iconPath = [UIBezierPath bezierPathWithRect:iconRect];
    //        } else {
    //            iconPath = [UIBezierPath bezierPathWithOvalInRect:iconRect];
    //        }
    //        [iconColor setStroke];
    //        iconPath.lineWidth = iconStrokeWidth;
    //        [iconPath stroke];
    //        CGContextAddPath(context, iconPath.CGPath);
    //
    //        // draw indicator
    //        if (selected) {
    //            UIBezierPath* indicatorPath;
    //            CGRect indicatorRect = CGRectMake((iconSize - indicatorSize) / 2, (iconSize - indicatorSize) / 2, indicatorSize, indicatorSize);
    //            if (self.isIconSquare) {
    //                indicatorPath = [UIBezierPath bezierPathWithRect:indicatorRect];
    //            } else {
    //                indicatorPath = [UIBezierPath bezierPathWithOvalInRect:indicatorRect];
    //            }
    //            [indicatorColor setFill];
    //            [indicatorPath fill];
    //            CGContextAddPath(context, indicatorPath.CGPath);
    //        }
    //
    //        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsPopContext();
    //        UIGraphicsEndImageContext();
    //
    //        image.accessibilityIdentifier = kGeneratedIconName;
    //        return image;
    //    }

    func touchDown() {
        //        selected(true)
    }

    func initRadioButton() {
        addTarget(self, action: #selector(touchDown), forControlEvents: UIControlEvents.TouchUpInside)
    }

    public override func prepareForInterfaceBuilder() {
        initRadioButton()
        drawButton()
    }


    //    #pragma mark - DLRadiobutton
    //
    //    + (void)groupModifing:(BOOL)chaining {
    //    _groupModifing = chaining;
    //    }
    //
    //    + (BOOL)isGroupModifing {
    //    return _groupModifing;
    //    }

    //    - (void)deselectOtherButtons {
    //    for (UIButton *button in self.otherButtons) {
    //    [button setSelected:NO];
    //    }
    //    }

//    - (DLRadioButton *)selectedButton {
//    if (!self.isMultipleSelectionEnabled) {
//    if (self.selected) {
//    return self;
//    } else {
//    for (DLRadioButton *radioButton in self.otherButtons) {
//    if (radioButton.selected) {
//    return radioButton;
//    }
//    }
//    }
//    }
//    return nil;
//    }
//
//    - (NSArray *)selectedButtons {
//    NSMutableArray *selectedButtons = [[NSMutableArray alloc] init];
//    if (self.selected) {
//    [selectedButtons addObject:self];
//    }
//    for (DLRadioButton *radioButton in self.otherButtons) {
//    if (radioButton.selected) {
//    [selectedButtons addObject:radioButton];
//    }
//    }
//    return selectedButtons;
//    }

//    #pragma mark - UIButton

//    - (UIColor *)titleColorForState:(UIControlState)state {
//    UIColor *normalColor = [super titleColorForState:UIControlStateNormal];
//    if (state == (UIControlStateSelected | UIControlStateHighlighted)) {
//    UIColor *selectedOrHighlightedColor = [super titleColorForState:UIControlStateSelected | UIControlStateHighlighted];
//    if (selectedOrHighlightedColor == normalColor || selectedOrHighlightedColor == nil) {
//    selectedOrHighlightedColor = [super titleColorForState:UIControlStateSelected];
//    }
//    if (selectedOrHighlightedColor == normalColor || selectedOrHighlightedColor == nil) {
//    selectedOrHighlightedColor = [super titleColorForState:UIControlStateHighlighted];
//    }
//    [self setTitleColor:selectedOrHighlightedColor forState:UIControlStateSelected | UIControlStateHighlighted];
//    }
//
//    return [super titleColorForState:state];
//    }

//    #pragma mark - UIControl

    func selected(selected: Bool) {
        super.selected = selected

        if selected {
            //deselect others
        }
    }


//    #pragma mark - UIView


    public required override init(frame: CGRect) {
        super.init(frame: frame)

        initRadioButton()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initRadioButton()
    }

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        drawButton()
    }
}
