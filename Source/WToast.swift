//
//  WToast.swift
//  Pods

import Foundation
import UIKit
import SnapKit

public class WToast : UIView {
    private var message = ""
    private var title: String?
    private var icon: UIImage?
    
    private var messageLabel = UILabel(frame: CGRectZero)
    private var titleLabel: UILabel?
    private var iconImageView: UIImageView?
    
    private var toastColor = UIColor.orangeColor()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(message: String, title: String? = nil, icon: UIImage? = nil) {
        self.init(frame: CGRectZero)
        
        self.message = message
    }
    
    public func commonInit() {
        addSubview(messageLabel)
        
        if title != nil {
            titleLabel = UILabel(frame: CGRectZero)
            addSubview(titleLabel!)
        }
        
        if icon != nil {
            iconImageView = UIImageView(frame: CGRectZero)
            addSubview(iconImageView!)
        }
        
        setupUI()
    }
    
    public func setupUI() {
        backgroundColor = toastColor
        
        if let icon = icon {
            iconImageView?.snp_remakeConstraints{ (make) in
                make.left.equalTo(self).offset(18)
                make.top.equalTo(self).offset(6)
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            iconImageView?.image = icon
        }
        
        if let title = title {
            titleLabel?.snp_remakeConstraints{ (make) in
                if icon != nil {
                    make.left.equalTo(iconImageView!).offset(6)
                } else {
                    make.left.equalTo(self).offset(18)
                }
                make.top.equalTo(self).offset(6)
                make.height.equalTo(20)
                make.right.equalTo(self).offset(-18)
            }
            titleLabel?.text = title
            titleLabel?.font = UIFont.systemFontOfSize(20)
        }
        
        messageLabel.snp_remakeConstraints { (make) in
            make.left.equalTo(self).offset(18)
            make.right.equalTo(self).offset(-18)
            make.bottom.equalTo(self).offset(-6)
            
            if title != nil || icon != nil {
                make.top.equalTo(titleLabel!.snp_bottom).offset(12)
            } else {
                make.top.equalTo(self).offset(6)
            }
        }
        messageLabel.text = message
        messageLabel.font = UIFont.systemFontOfSize(16)
        
        layoutIfNeeded()
    }
}
