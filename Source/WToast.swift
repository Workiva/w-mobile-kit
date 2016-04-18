//
//  WToast.swift
//  Pods

import Foundation
import UIKit
import SnapKit

public class WToastManager: NSObject {
    public static let sharedInstance = WToastManager()
    
    public var rootViewController: UIViewController? {
        get {
            return UIApplication.sharedApplication().windows.first?.rootViewController
        }
    }
    
    private override init() {
        super.init()
    }
    
    public func showToast(message: String) {
        let toast = WToastView(message)
        
        let rootVC = rootViewController
        let window = UIApplication.sharedApplication().windows.first
        window!.addSubview(toast)
        toast.snp_makeConstraints { (make) in
            make.centerX.equalTo(window!)
            make.width.equalTo(window!).multipliedBy(0.8)
            make.top.equalTo(window!.snp_bottom)
            make.height.equalTo(64)
        }
        window!.layoutIfNeeded()
        
        toast.snp_remakeConstraints { (make) in
            make.centerX.equalTo(window!)
            make.width.equalTo(window!).multipliedBy(0.8)
            make.bottom.equalTo(window!).offset(-32)
            make.height.equalTo(64)
        }

        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            window!.layoutIfNeeded()
            }) { (finished) in
                UIView.animateWithDuration(0.3, delay: 1.0, options: .CurveEaseInOut, animations: {
                    toast.snp_remakeConstraints { (make) in
                        make.centerX.equalTo(window!)
                        make.width.equalTo(window!).multipliedBy(0.8)
                        make.top.equalTo(window!.snp_bottom)
                        make.height.equalTo(64)
                    }
                    
                    window!.layoutIfNeeded()
                    }, completion: { (finished) in
                        toast.removeFromSuperview()
                })
        }
        
        toast.setupUI()
    }
}

public class WToastView : UIView {
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
        
        commonInit()
    }
    
    public convenience init(_ message: String, title: String? = nil, icon: UIImage? = nil) {
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
            make.bottom.equalTo(self).offset(-6)
            make.right.equalTo(self).offset(-18)
            
            if title != nil || icon != nil {
                make.top.equalTo(titleLabel!.snp_bottom).offset(12)
            } else {
                make.top.equalTo(self).offset(6)
            }
        }
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.backgroundColor = UIColor.redColor()
        
        layoutIfNeeded()
    }
}
