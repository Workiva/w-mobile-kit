//
//  TextFieldExamplesVC.swift
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

open class TextFieldsExamplesVC: WSideMenuContentVC {
    @IBOutlet var storyboardTextField: WTextField?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Text Field with no icons.
        let noIconsLabel = UILabel()
        noIconsLabel.text = "This WTextField has no icons."
        noIconsLabel.textAlignment = .center
        view.addSubview(noIconsLabel)
        noIconsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(storyboardTextField!.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let noIconsTextField = WTextField()
        view.addSubview(noIconsTextField)
        noIconsTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        // MARK: Text Field with a left icon.
        let leftIconLabel = UILabel()
        leftIconLabel.text = "This WTextField has a left icon."
        leftIconLabel.textAlignment = .center
        view.addSubview(leftIconLabel)
        leftIconLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsTextField.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let leftIconTextField = WTextField()
        leftIconTextField.leftImage = UIImage(named: "person")
        view.addSubview(leftIconTextField)
        leftIconTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        // MARK: Text Field with a right icon.
        let rightIconLabel = UILabel()
        rightIconLabel.text = "This WTextField has a right icon."
        rightIconLabel.textAlignment = .center
        view.addSubview(rightIconLabel)
        rightIconLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconTextField.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let rightIconTextField = WTextField()
        rightIconTextField.rightImage = UIImage(named: "gear")
        rightIconTextField.textColor = UIColor.black
        rightIconTextField.placeholder = "This has black text."
        view.addSubview(rightIconTextField)
        rightIconTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(rightIconLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        rightIconTextField.imageSquareSize = 32
        rightIconTextField.bottomLineColor = .black
        rightIconTextField.tintColor = .black
        rightIconTextField.bottomLineWidth = 2

        // MARK: Text Field with both icons.
        let bothIconLabel = UILabel()
        bothIconLabel.text = "This WTextField has both icons."
        bothIconLabel.textAlignment = .center
        view.addSubview(bothIconLabel)
        bothIconLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(rightIconTextField.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let bothIconTextField = WTextField()
        bothIconTextField.leftImage = UIImage(named: "person")
        bothIconTextField.rightImage = UIImage(named: "gear")
        view.addSubview(bothIconTextField)
        bothIconTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bothIconLabel.snp.bottom).offset(4)
            make.width.equalTo(view).offset(-10)
            make.height.equalTo(30)
        }

        // MARK: Text Field with clear icon.
        let clearIconLabel = UILabel()
        clearIconLabel.text = "This WTextField has a clear icon."
        clearIconLabel.textAlignment = .center
        view.addSubview(clearIconLabel)
        clearIconLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bothIconTextField.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let clearIconTextField = WTextField()
        clearIconTextField.rightImage = UIImage(named: "close")
        clearIconTextField.rightViewIsClearButton = true
        view.addSubview(clearIconTextField)
        clearIconTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(clearIconLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
}
