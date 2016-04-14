//
//  WUserLogo.swift
//  Pods

import Foundation
import UIKit

public class WUserLogo : UIView {
    public var initialsLabel = UILabel(frame: CGRectZero)
    
    public var circleLayer = CAShapeLayer()
    
    public var name : String? {
        didSet {
            setupUI()
        }
    }
    
    public var lineWidth:CGFloat = 1.0 {
        didSet {
            setupUI()
        }
    }
    
    public override var bounds : CGRect {
        didSet {
            if (!subviews.contains(initialsLabel)) {
                commonInit()
            }
            
            setupUI()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public convenience init(_ name: String) {
        self.init(frame: CGRectZero)
        
        self.name = name
    }
    
    public func commonInit() {
        addSubview(initialsLabel)
    }
    
    public func setupUI() {
        initialsLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(self).multipliedBy(0.8)
        }
        
        if let name = name {
            circleLayer.strokeColor = mapNameToColor(name).CGColor
            
            let attributedString = NSMutableAttributedString(string: name.getInitials())
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.6), range: NSRange(location: 0, length: 2))
            
            initialsLabel.attributedText = attributedString
            initialsLabel.textAlignment = NSTextAlignment.Center
            initialsLabel.font = UIFont.systemFontOfSize(frame.width / 2.5)
            initialsLabel.adjustsFontSizeToFitWidth = true
            initialsLabel.textColor = mapNameToColor(name)
            
        } else {
            circleLayer.strokeColor = UIColor.blueColor().CGColor
        }
        
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        
        let path = UIBezierPath(arcCenter: center, radius: frame.width / 2 - 1, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        circleLayer.path = path.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = lineWidth
        
        layer.addSublayer(circleLayer)
    }
    
    public func mapNameToColor(name: String) -> UIColor {
        let final = abs((Double(name.hashValue) / M_LOG2E) % 5)
        
        switch final {
        case 0:
            return UIColor(hex: 0x42AD48)
        case 1:
            return UIColor(hex: 0xA71B19)
        case 2:
            return UIColor(hex: 0x026DCE)
        case 3:
            return UIColor(hex: 0x813296)
        case 4:
            return UIColor(hex: 0xF26C21)
        default:
            return UIColor.blackColor()
        }
    }
}

public extension String {
    public func getInitials() -> String {
        let spaceRange = self.rangeOfString(" ")
        
        if let spaceRange = spaceRange {
            let firstName = self.substringToIndex(spaceRange.startIndex)
            let lastName = self.substringFromIndex(spaceRange.endIndex)
            
            let firstInitial = firstName.characters.first! as Character
            let secondInitial = lastName.characters.first! as Character
            
            return String(firstInitial) + String(secondInitial)
        }
        
        return self.characters.count > 0 ? String(self.characters.first) : ""
    }
}