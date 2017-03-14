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
    let contentView = UIView()
    var views: [UIView] = []
    var autoViewLayoutVC = WAutoViewLayoutVC()

    let descriptionLabelHeight: CGFloat = 175
    let sideAutoViewLayoutPadding: CGFloat = 30.0
    let topPadding: CGFloat = 20.0

    let descriptionLabel = UILabel()
    let randomButton = UIButton(type: UIButtonType.RoundedRect)

    public override func viewDidLoad() {
        super.viewDidLoad()

        randomButton.backgroundColor = .lightGrayColor()
        randomButton.tintColor = .greenColor()
        randomButton.setTitle("Randomize Count", forState: UIControlState.Normal)
        randomButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        randomButton.addTarget(self, action: #selector(AutoViewLayoutExampleVC.randomizeViewCount), forControlEvents: .TouchUpInside)
        view.addSubview(randomButton)
        randomButton.snp_remakeConstraints { (make) in
            make.top.equalTo(view.snp_top).offset(topPadding)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }

        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.snp_remakeConstraints { (make) in
            make.top.equalTo(randomButton.snp_bottom).offset(topPadding)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview()
        }

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFontOfSize(16.0)
        descriptionLabel.text = "    Automatically adds as many of the provided views as possible to each row as determinted by the controller's width and wraps to the next row for any remaining views.\n    Adjusts the height to fit the content, which is available as a property making it great to use for static headers or any view containing a set amount of content!"
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.left.equalTo(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(descriptionLabelHeight)
        }

        // Step 1: Gather your views you wish to display as a list. Their frames must be set.
        let viewsList = WUtils.generateExampleViews(10)

        // Step 2: Add views list to controller
        autoViewLayoutVC.views = viewsList

        // Optional: Customize autoViewLayoutVC
        autoViewLayoutVC.leftSpacing = 2
        autoViewLayoutVC.rightSpacing = 2
        autoViewLayoutVC.topSpacing = 2
        autoViewLayoutVC.bottomSpacing = 2
        autoViewLayoutVC.collectionView.backgroundColor = .whiteColor()

        // Step 3: Add autoViewLayoutVC to current view controller
        addViewControllerToContainer(contentView, viewController: autoViewLayoutVC)

        // Or Step 3: Add controller's view to your view (can cause some view issues)
//        scrollView.addSubview(autoViewLayoutVC.view)

        // Step 4: Adjust the height and width of the view
        autoViewLayoutVC.view.snp_remakeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(topPadding)
            make.left.equalToSuperview().offset(sideAutoViewLayoutPadding)
            make.width.equalToSuperview().offset(-(sideAutoViewLayoutPadding*2))
            make.height.equalTo(autoViewLayoutVC.fittedHeight)
        }

        // Optional: Set the content size to make the scroll view scroll
        scrollView.contentSize = scrollContentSize()

        // Optional: Can change the views and the autoViewLayoutVC will update the UI
        let sampleViews = WUtils.generateExampleViews(30)
        autoViewLayoutVC.views = sampleViews

        // Optional: Set the content size to make the scroll view scroll
        scrollView.contentSize = scrollContentSize()

        // Optional: Compare if the estimated height equals your actual height!
        let estimatedHeight = WAutoViewLayoutVC.estimatedFittedHeight(sampleViews, constrainedWidth: (view.frame.size.width-(sideAutoViewLayoutPadding*2)), leftSpacing: 2, rightSpacing: 2, topSpacing: 2, bottomSpacing: 2)
        let actualHeight = autoViewLayoutVC.fittedHeight

        if (estimatedHeight == actualHeight) {
            print("WAutoViewLayoutVC estimated and actual heights are the same!")
        }
    }

    // Required if using addSubview instead of addViewControllerToContainer
//    public override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//
//        autoViewLayoutVC.refreshAutoViewLayout()
//    }

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition(nil, completion:  { [weak self] _ in
            if let weakSelf = self {
                weakSelf.scrollView.contentSize = weakSelf.scrollContentSize()
            }
        })
    }

    public func randomizeViewCount() {
        // Optional: Can change the views and the autoViewLayoutVC will update the UI
        let randomCount = Int(arc4random_uniform(55) + 5)
        autoViewLayoutVC.views = WUtils.generateExampleViews(randomCount)

        // Optional: Set the content size to make the scroll view scroll
        scrollView.contentSize = scrollContentSize()
    }

    public func scrollContentSize() -> CGSize {
        return CGSize(width: view.frame.size.width, height: descriptionLabelHeight + topPadding + autoViewLayoutVC.fittedHeight)
    }
}
