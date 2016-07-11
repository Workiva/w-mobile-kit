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

public class WLoadingModal: UIView {
    public var spinnerView: WSpinner = WSpinner()

    public var spinnerSize: CGFloat = 44 {
        didSet {
            self.remakeSpinnerConstraints()
        }
    }

    public var paddingBetweenViewTopAndSpinner: CGFloat = 32 {
        didSet {
            self.remakeAllConstraints()
        }
    }

    public var paddingBetweenTitleAndSpinner: CGFloat = 32 {
        didSet {
            self.remakeTitleConstraints()
        }
    }

    public var paddingBetweenDescriptionAndTitle: CGFloat = 32 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

    public var titleLabel: UILabel = UILabel()

    public var titleLabelHeight: CGFloat = 20 {
        didSet  {
            self.remakeTitleConstraints()
        }
    }

    public var descriptionLabel: UILabel = UILabel()

    public var descriptionLabelHeight: CGFloat = 60 {
        didSet {
            self.remakeDescriptionConstraints()
        }
    }

    public var addBlurBackground: Bool = true {
        didSet {
            blurEffectView.removeFromSuperview()
        }
    }

    public var blurEffectStyle: UIBlurEffectStyle = .Dark {
        didSet {
            remakeBlurBackground()
        }
    }

    public var blurEffectAlpha: CGFloat = 0.8 {
        didSet {
            remakeBlurBackground()
        }
    }

    public var blurEffectAutoResizingMask: UIViewAutoresizing = [.FlexibleWidth, .FlexibleHeight] {
        didSet {
            remakeBlurBackground()
        }
    }

    public var blurEffect = UIBlurEffect()

    public var blurEffectView = UIVisualEffectView()

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

    private func commonInit() {
        backgroundColor = WThemeManager.sharedInstance.currentTheme.loadingModalBackgroundColor

        if (addBlurBackground) {
            remakeBlurBackground()
            addSubview(blurEffectView)
        }

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

    private func remakeBlurBackground() {
        blurEffectView.frame = frame
        blurEffectView.alpha = blurEffectAlpha
        blurEffectView.autoresizingMask = blurEffectAutoResizingMask
    }

    private func remakeAllConstraints() {
        remakeSpinnerConstraints()
        remakeTitleConstraints()
        remakeDescriptionConstraints()
    }

    private func remakeSpinnerConstraints() {
        spinnerView.snp_remakeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(paddingBetweenViewTopAndSpinner)
            make.centerX.equalTo(self)
            make.width.equalTo(spinnerSize)
            make.height.equalTo(spinnerSize)
        }
    }

    private func remakeTitleConstraints() {
        titleLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(spinnerView.snp_bottom).offset(paddingBetweenTitleAndSpinner)
            make.centerX.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(20)
        }
    }

    private func remakeDescriptionConstraints() {
        descriptionLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(paddingBetweenDescriptionAndTitle)
            make.centerX.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(descriptionLabelHeight)
        }
    }

    public func show(view: UIView) {
        self.show(view, insets: UIEdgeInsetsMake(0, 0, 0, 0))
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