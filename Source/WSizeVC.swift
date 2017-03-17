//
//  WSizeVC.swift
//  WMobileKit
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

import UIKit
import Foundation

public enum SizeType {
    case iPad, iPhone, unknown
}

open class WSizeVC: UIViewController {
    open var contentContainerSidePadding: CGFloat = 0
    open var contentContainerTopPadding: CGFloat = 0
    open var contentContainerBottomPadding: CGFloat = 0

    var _contentContainer = UIView()
    /// Add all content to this view so padding can easily be added.
    /// Needs to be added to the VC in the viewDidLoad()
    open func sizeContentContainer() -> UIView {
        return _contentContainer
    }

    /// Must be checked on viewWillAppear() or later for an accurate result
    open func currentSizeType() -> SizeType {
        if ((traitCollection.horizontalSizeClass == .unspecified) || (traitCollection.verticalSizeClass == .unspecified)) {
            return .unknown
        } else if ((traitCollection.horizontalSizeClass == .compact) || (traitCollection.verticalSizeClass == .compact)) {
            return .iPhone
        } else {
            return .iPad
        }
    }

    /// Should be accessed externally through traitCollection.horizontalSizeClass for the latest value
    var horizontalSizeClass = UIUserInterfaceSizeClass.unspecified {
        didSet {
            if oldValue != horizontalSizeClass {
                horizontalSizeClassChanged(horizontalSizeClass)
            }
        }
    }

    /// Should be accessed externally through traitCollection.verticalSizeClass for the latest value
    var verticalSizeClass = UIUserInterfaceSizeClass.unspecified {
        didSet {
            if oldValue != verticalSizeClass {
                verticalSizeClassChanged(verticalSizeClass)
            }
        }
    }

    func updateSizes() {
        horizontalSizeClass = traitCollection.horizontalSizeClass
        verticalSizeClass = traitCollection.verticalSizeClass
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSizes()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateSizes()
    }

    open func horizontalSizeClassChanged(_ horizontalSizeClass: UIUserInterfaceSizeClass) {}
    open func verticalSizeClassChanged(_ verticalSizeClass: UIUserInterfaceSizeClass) {}

    open func updateContentContainerPadding() {
        if (view.subviews.contains(sizeContentContainer())) {
            sizeContentContainer().snp.updateConstraints{ (make) in
                make.left.equalTo(view).offset(contentContainerSidePadding)
                make.right.equalTo(view).offset(-contentContainerSidePadding)
                make.top.equalTo(view).offset(contentContainerTopPadding)
                make.bottom.equalTo(view).offset(-contentContainerBottomPadding)
            }
        }
    }
}
