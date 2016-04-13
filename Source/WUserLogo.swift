//
//  WUserLogo.swift
//  Pods

import Foundation
import UIKit

public class WUserLogo : UIView {
    public var circleBorder = UIView(frame: CGRectZero)
    public var innerCircle = UIView(frame: CGRectZero)
    public var initialsLabel = UILabel(frame: CGRectZero)
    
    public override var frame: CGRect {
        didSet {
            setupUI()
        }
    }
    
    public var initials : String? {
        didSet {
            setupUI()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public func commonInit() {
        addSubview(circleBorder)
        circleBorder.addSubview(innerCircle)
        innerCircle.addSubview(initialsLabel)
        initialsLabel.textAlignment = NSTextAlignment.Center
        initialsLabel.font = UIFont.boldSystemFontOfSize(40)
        initialsLabel.adjustsFontSizeToFitWidth = true
    }
    
    public func setupUI() {
        circleBorder.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        circleBorder.backgroundColor = UIColor.darkGrayColor()
        
        innerCircle.snp_makeConstraints { (make) in
            make.centerX.equalTo(circleBorder)
            make.centerY.equalTo(circleBorder)
            make.width.equalTo(circleBorder).multipliedBy(0.9)
            make.height.equalTo(circleBorder).multipliedBy(0.9)
        }
        innerCircle.backgroundColor = UIColor.lightGrayColor()
        
        initialsLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(innerCircle)
            make.centerX.equalTo(innerCircle)
            make.width.equalTo(innerCircle).multipliedBy(0.8)
            make.height.equalTo(innerCircle).multipliedBy(0.8)
        }
        
        layoutIfNeeded()
        
        circleBorder.clipsToBounds = true
        innerCircle.clipsToBounds = true
        
        circleBorder.layer.cornerRadius = circleBorder.frame.width / 2
        innerCircle.layer.cornerRadius = innerCircle.frame.width / 2
        
        if let initials = initials {
            initialsLabel.text = initials
        }
    }
}