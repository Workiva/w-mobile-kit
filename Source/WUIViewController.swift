//
//  WUIViewController.swift
//  Pods

import UIKit
import SnapKit

protocol WUIProtocol {
    var staticHeader: UIView? { get }
    var staticHeaderHeight: CGFloat { get }
    var contentView: UIView? { get }
    var staticFooter: UIView? { get }
    var staticFooterHeight: CGFloat { get }
    
    func layoutUI()
    func updateUI()
}

extension UIViewController: WUIProtocol {
    var staticHeader: UIView? {
        return nil
    }
    
    var staticHeaderHeight: CGFloat {
        return 0.0
    }
    
    var contentView: UIView? {
        return nil
    }
    
    var staticFooter: UIView? {
        return nil
    }
    
    var staticFooterHeight: CGFloat {
        return 0.0
    }
    
    func layoutUI() {
        if let contentView = contentView {
            view.addSubview(contentView)
            contentView.snp_makeConstraints() { (make) in
                make.left.equalTo(view)
                make.top.equalTo(view)
                make.right.equalTo(view)
                make.bottom.equalTo(view)
            }
        }
        
        if let staticHeader = staticHeader {
            view.addSubview(staticHeader)
            staticHeader.snp_makeConstraints() { (make) in
                make.left.equalTo(view)
                make.top.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(staticHeaderHeight)
            }
            
            if let contentView = contentView {
                contentView.snp_updateConstraints() { (make) in
                    make.top.equalTo(staticHeader.snp_bottom)
                }
            }
        }
        
        if let staticFooter = staticFooter {
            view.addSubview(staticFooter)
            staticFooter.snp_makeConstraints() { (make) in
                make.left.equalTo(view)
                make.bottom.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(staticFooterHeight)
            }
            
            if let contentView = contentView {
                contentView.snp_updateConstraints() { (make) in
                    make.top.equalTo(staticFooter.snp_top)
                }
            }
        }
    }
    
    func updateUI() {}
}