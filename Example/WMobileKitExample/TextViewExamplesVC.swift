//
//  TextViewExamplesVC.swift
//  WMobileKitExample
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
import WMobileKit

public class TextViewExamplesVC: WSideMenuContentVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Text View with placeholder text.
        let noIconsLabel = UILabel()
        noIconsLabel.text = "This WTextView has placeholder text."
        noIconsLabel.textAlignment = .Center
        view.addSubview(noIconsLabel)
        noIconsLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        let noIconsTextView = WTextView()
        noIconsTextView.editable = true
        noIconsTextView.scrollEnabled = true
        noIconsTextView.placeholderText = "Type something to see this disappear"
        view.addSubview(noIconsTextView)
        noIconsTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsLabel.snp_bottom).offset(4)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        // MARK: Text View with a left icon.
        let leftIconLabel = UILabel()
        leftIconLabel.text = "This WTextView has a left icon."
        leftIconLabel.textAlignment = .Center
        view.addSubview(leftIconLabel)
        leftIconLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsTextView.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        let leftIconTextView = WTextView()
        leftIconTextView.editable = true
        leftIconTextView.placeholderText = "Text colors and alignment can be set"
        leftIconTextView.scrollEnabled = true
        leftIconTextView.leftImage = UIImage(named: "person")
        leftIconTextView.textAlignment = .Right
        leftIconTextView.textColor = UIColor.redColor()
        leftIconTextView.placeholderTextColor = UIColor.purpleColor().colorWithAlphaComponent(0.3)

        view.addSubview(leftIconTextView)
        leftIconTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconLabel.snp_bottom).offset(4)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        // MARK: Text View with both.
        let bothLabel = UILabel()
        bothLabel.text = "This WTextView has placeholder text and a left icon."
        bothLabel.textAlignment = .Center
        bothLabel.numberOfLines = 2
        view.addSubview(bothLabel)
        bothLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconTextView.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
        
        let bothTextView = WTextView()
        bothTextView.editable = true
        bothTextView.scrollEnabled = true
        bothTextView.placeholderText = "Enter the name of a person"
        bothTextView.leftImage = UIImage(named: "person")
        view.addSubview(bothTextView)
        bothTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bothLabel.snp_bottom).offset(4)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }

        let defaultTextField = UITextField()
        defaultTextField.placeholder = "Testholder"
        defaultTextField.text = "Testholder"
        defaultTextField.backgroundColor = .whiteColor()
        defaultTextField.textColor = .redColor()
        defaultTextField.font = bothTextView.font
        view.addSubview(defaultTextField)
        defaultTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bothTextView.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
}