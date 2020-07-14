//
//  MarkdownTextViewExamplesVC.swift
//  WMobileKitExample
//
//  Copyright 2017 Workiva Inc.
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

open class MarkdownTextViewExamplesVC: WSideMenuContentVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
                
        // MARK: Text View with correct Markdown URL
        let correctTextView = WMarkdownTextView("This WMarkdownTextView has a [correct]() Markdown URL")
        correctTextView.backgroundColor = .clear
        correctTextView.textAlignment = .center
        view.addSubview(correctTextView)
        correctTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let incorrectTextView = WMarkdownTextView("This WMarkdownTextView has an [incorrect](() Markdown URL")
        incorrectTextView.textAlignment = .center
        view.addSubview(incorrectTextView)
        incorrectTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(correctTextView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let multipleCorrectTextView = WMarkdownTextView("This WMarkdownTextView has [multiple]() correct [Markdown]() URLs")
        multipleCorrectTextView.textAlignment = .center
        multipleCorrectTextView.backgroundColor = .clear
        multipleCorrectTextView.linkTextAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                      NSAttributedString.Key.foregroundColor: UIColor.purple]
        view.addSubview(multipleCorrectTextView)
        multipleCorrectTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(incorrectTextView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let mixedTextView = WMarkdownTextView()
        mixedTextView.text = "This WMarkdownTextView has [some](() [incorrect]]() URLs with [some]() correct [ones]() as well"
        mixedTextView.textAlignment = .center
        view.addSubview(mixedTextView)
        mixedTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(multipleCorrectTextView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(45)
        }
        
        let complexTextView = WMarkdownTextView()
        complexTextView.text = "This WMarkdownTextView has a [co[mpl]ex]   () URL"
        complexTextView.backgroundColor = .clear
        complexTextView.textAlignment = .center
        complexTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow,
                                              NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        view.addSubview(complexTextView)
        complexTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(mixedTextView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(35)
        }
        
        let realLinkTextView = WMarkdownTextView("This WMarkdownTextView has a link that will take you directly to [Wdesk.com](https://wdesk.com)")
        realLinkTextView.textAlignment = .center
        view.addSubview(realLinkTextView)
        realLinkTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(complexTextView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(45)
        }
    }
}
