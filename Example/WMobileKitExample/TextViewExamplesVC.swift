//
//  TextViewExamplesVC.swift
//  WMobileKitExample

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