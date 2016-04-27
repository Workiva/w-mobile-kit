//
//  WLoadingModal.swift
//  WMobileKit

import Foundation
import UIKit

public class WLoadingModal: UIView {
    public var spinnerView: WSpinner = WSpinner()
    public var titleLabel: UILabel = UILabel()
    public var descriptionLabel: UILabel = UILabel()

    // MARK: - Inits
    public convenience init(_ backgroundColor: UIColor, title: String, description: String) {
        self.init()

        commonInit()

        self.backgroundColor = backgroundColor
        titleLabel.text = title
        descriptionLabel.text = description
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clearColor()

        spinnerView.indeterminate = true
        addSubview(spinnerView)
        spinnerView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(spinnerView.snp_bottom).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }

        descriptionLabel.textColor = .whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(180)
            make.height.equalTo(60)
        }
    }

    public func show(view: UIView, insets: UIEdgeInsets) {
        hide()

        view.addSubview(self)

        self.snp_makeConstraints { (make) in
            make.top.equalTo(insets.top)
            make.right.equalTo(insets.right)
            make.bottom.equalTo(insets.bottom)
            make.left.equalTo(insets.left)
        }
    }

    public func hide() {
        if (superview != nil) {
            removeFromSuperview()
        }
    }

    public func setProgress(progress: CGFloat) {
        if (spinnerView.indeterminate) {
            spinnerView.indeterminate = false
        }

        spinnerView.progress = progress
    }
}