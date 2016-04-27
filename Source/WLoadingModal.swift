//
//  WLoadingModal.swift
//  WMobileKit

import Foundation
import UIKit

public class WLoadingModal: UIView {
    public var spinnerView: WSpinner = WSpinner()

    public var spinnerSize: CGFloat = 44 {
        didSet {
            self.remakeSpinnerConstraints()
        }
    }

    public var titleLabel: UILabel = UILabel()

    public var titleLabelWidth: CGFloat = 120 {
        didSet {
            self.remakeTitleConstraints()
        }
    }

    public var titleLabelHeight: CGFloat = 20 {
        didSet  {
            self.remakeTitleConstraints()
        }
    }

    public var descriptionLabel: UILabel = UILabel()

    public var descriptionLabelWidth: CGFloat = 180 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

    public var descriptionLabelHeight: CGFloat = 60 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

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
        remakeSpinnerConstraints()

        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        remakeTitleConstraints()

        descriptionLabel.textColor = .whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        remakeDescriptionConstraints()
    }

    private func remakeSpinnerConstraints() {
        spinnerView.snp_remakeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(spinnerSize)
            make.height.equalTo(spinnerSize)
        }
    }

    private func remakeTitleConstraints() {
        titleLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(spinnerView.snp_bottom).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(titleLabelWidth)
            make.height.equalTo(20)
        }
    }

    private func remakeDescriptionConstraints() {
        descriptionLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(32)
            make.centerX.equalTo(self)
            make.width.equalTo(descriptionLabelWidth)
            make.height.equalTo(descriptionLabelHeight)
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