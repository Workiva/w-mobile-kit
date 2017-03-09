//
//  AutoViewLayoutExampleVC.swift
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

public class AutoViewLayoutExampleVC: WSideMenuContentVC {
    let scrollView = UIScrollView()

    var views: [UIView] = []
    var autoViewLayoutVC = WAutoViewLayoutVC()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Step 1: Add views list to controller
        autoViewLayoutVC.views = WUtils.generateExampleViews(18)

        scrollView.contentSize = view.frame.size
        view.addSubview(scrollView)
        scrollView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }

        // Step 2: Add controller's view to your view
        scrollView.addSubview(autoViewLayoutVC.view)
        autoViewLayoutVC.view.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()

            // Step 3: Adjust the height of the view
            make.height.equalTo(autoViewLayoutVC.fittedHeight)
        }
    }
}
