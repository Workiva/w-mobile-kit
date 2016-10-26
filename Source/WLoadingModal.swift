//
//  WLoadingModal.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import UIKit

open class WLoadingModal: UIView {
    open var spinnerView: WSpinner = WSpinner()

    open var spinnerSize: CGFloat = 44 {
        didSet {
            self.remakeSpinnerConstraints()
        }
    }

    open var paddingBetweenViewTopAndSpinner: CGFloat = 32 {
        didSet {
            self.remakeAllConstraints()
        }
    }

    open var paddingBetweenTitleAndSpinner: CGFloat = 32 {
        didSet {
            self.remakeTitleConstraints()
        }
    }

    open var paddingBetweenDescriptionAndTitle: CGFloat = 32 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

    open var titleLabel: UILabel = UILabel()

    open var titleLabelHeight: CGFloat = 20 {
        didSet  {
            self.remakeTitleConstraints()
        }
    }

    open var descriptionLabel: UILabel = UILabel()

    open var descriptionLabelHeight: CGFloat = 60 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

    open var addBlurBackground: Bool = true {
        didSet {
            blurEffectView.removeFromSuperview()

            // Case where we are changing it from false to true.
            if (addBlurBackground) {
                remakeBlurBackground()
                addSubview(blurEffectView)
            }
        }
    }

    open var blurEffectStyle: UIBlurEffectStyle = .dark {
        didSet {
            remakeBlurBackground()
        }
    }

    open var blurEffectAutoResizingMask: UIViewAutoresizing = [.flexibleWidth, .flexibleHeight] {
        didSet {
            remakeBlurBackground()
        }
    }

    open var blurEffect = UIBlurEffect()

    open var blurEffectView = UIVisualEffectView()

    // MARK: - Inits
    public convenience init(_ title: String) {
        self.init()

        commonInit()

        titleLabel.text = title
    }

    public convenience init(_ backgroundColor: UIColor, title: String) {
        self.init()

        commonInit()

        self.backgroundColor = backgroundColor
        titleLabel.text = title
    }

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

    fileprivate func commonInit() {
        backgroundColor = WThemeManager.sharedInstance.currentTheme.loadingModalBackgroundColor

        if (addBlurBackground) {
            remakeBlurBackground()
            addSubview(blurEffectView)
        }

        spinnerView.indeterminate = true
        addSubview(spinnerView)
        remakeSpinnerConstraints()

        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        remakeTitleConstraints()

        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        remakeDescriptionConstraints()
    }

    fileprivate func remakeBlurBackground() {
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurEffectView.effect = blurEffect

        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = blurEffectAutoResizingMask
    }

    fileprivate func remakeAllConstraints() {
        remakeSpinnerConstraints()
        remakeTitleConstraints()
        remakeDescriptionConstraints()
    }

    fileprivate func remakeSpinnerConstraints() {
        spinnerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(paddingBetweenViewTopAndSpinner)
            make.centerX.equalTo(self)
            make.width.equalTo(spinnerSize)
            make.height.equalTo(spinnerSize)
        }
    }

    fileprivate func remakeTitleConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(spinnerView.snp.bottom).offset(paddingBetweenTitleAndSpinner)
            make.centerX.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(20)
        }
    }

    fileprivate func remakeDescriptionConstraints() {
        descriptionLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(paddingBetweenDescriptionAndTitle)
            make.centerX.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(descriptionLabelHeight)
        }
    }

    open func show(_ view: UIView) {
        self.show(view, insets: UIEdgeInsetsMake(0, 0, 0, 0))
    }

    open func show(_ view: UIView, insets: UIEdgeInsets) {
        hide()

        view.addSubview(self)

        self.snp.makeConstraints { (make) in
            make.top.equalTo(insets.top)
            make.right.equalTo(insets.right)
            make.bottom.equalTo(insets.bottom)
            make.left.equalTo(insets.left)
        }
    }

    open func hide() {
        if (superview != nil) {
            removeFromSuperview()
        }
    }

    open func setProgress(_ progress: CGFloat) {
        if (spinnerView.indeterminate) {
            spinnerView.indeterminate = false
        }

        spinnerView.progress = progress
    }
}
