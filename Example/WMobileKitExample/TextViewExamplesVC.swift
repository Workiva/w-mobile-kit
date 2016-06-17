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
        
        // MARK: Text View with correct Markdown URL
        let correctTextView = WTextView("This WTextView has a [correct]() Markdown URL")
        correctTextView.backgroundColor = .clearColor()
        correctTextView.textAlignment = .Center
        view.addSubview(correctTextView)
        correctTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let incorrectTextView = WTextView("This WTextView has an [incorrect](() Markdown URL")
        incorrectTextView.textAlignment = .Center
        view.addSubview(incorrectTextView)
        incorrectTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(correctTextView.snp_bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let multipleCorrectTextView = WTextView("This WTextView has [multiple]() correct [Markdown]() URLs")
        multipleCorrectTextView.textAlignment = .Center
        multipleCorrectTextView.backgroundColor = .clearColor()
        multipleCorrectTextView.linkTextAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                                                      NSForegroundColorAttributeName: UIColor.purpleColor()]
        view.addSubview(multipleCorrectTextView)
        multipleCorrectTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(incorrectTextView.snp_bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let mixedTextView = WTextView()
        mixedTextView.text = "This WTextView has [some](() [incorrect]]() URLs with [some]() correct [ones]() as well"
        mixedTextView.textAlignment = .Center
        view.addSubview(mixedTextView)
        mixedTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(multipleCorrectTextView.snp_bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(45)
        }
        
        let complexTextView = WTextView()
        complexTextView.text = "This WTextView has a [co[mpl]ex]   () URL"
        complexTextView.backgroundColor = .clearColor()
        complexTextView.textAlignment = .Center
        complexTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.yellowColor(),
                                              NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue]
        view.addSubview(complexTextView)
        complexTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(mixedTextView.snp_bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let realLinkTextView = WTextView("This WTextView has a link that will take you directly to [Wdesk.com](https://wdesk.com)")
        realLinkTextView.textAlignment = .Center
        view.addSubview(realLinkTextView)
        realLinkTextView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(complexTextView.snp_bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(45)
        }
    }
}