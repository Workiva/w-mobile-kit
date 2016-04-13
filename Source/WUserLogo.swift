//
//  WUserLogo.swift
//  Pods

import Foundation
import UIKit

public class WUserLogo : UIView {
    public var initialsLabel = UILabel(frame: CGRectZero)
    
    public var circleLayer = CAShapeLayer()
    
    public var initials : String? {
        didSet {
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
    
    public func commonInit() {
        addSubview(initialsLabel)
    }
    
    public func setupUI() {
        initialsLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(self).multipliedBy(0.8)
        }
        
        if let initials = initials {
            initialsLabel.text = initials
            initialsLabel.textAlignment = NSTextAlignment.Center
            initialsLabel.font = UIFont.systemFontOfSize(frame.width / 2)
            initialsLabel.adjustsFontSizeToFitWidth = true
            initialsLabel.textColor = UIColor.blueColor()
        }
        
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        let path = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        circleLayer.path = path.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.blueColor().CGColor
        circleLayer.lineWidth = 3.0
        
        layer.addSublayer(circleLayer)
    }
}