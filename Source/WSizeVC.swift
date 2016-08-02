//
//  WSizeVC.swift
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

import UIKit
import Foundation

public enum SizeType {
    case iPad, iPhone, Unknown
}

public class WSizeVC: UIViewController {
    public var contentContainerSidePadding: CGFloat = 0
    public var contentContainerTopPadding: CGFloat = 0
    public var contentContainerBottomPadding: CGFloat = 0

    var _contentContainer = UIView()
    /// Add all content to this view so padding can easily be added.
    /// Needs to be added to the VC in the viewDidLoad()
    public func sizeContentContainer() -> UIView {
        return _contentContainer
    }

    /// Must be checked on viewWillAppear() or later for an accurate result
    public func currentSizeType() -> SizeType {
        if ((traitCollection.horizontalSizeClass == .Unspecified) || (traitCollection.verticalSizeClass == .Unspecified)) {
            return .Unknown
        } else if ((traitCollection.horizontalSizeClass == .Compact) || (traitCollection.verticalSizeClass == .Compact)) {
            return .iPhone
        } else {
            return .iPad
        }
    }

    /// Should be accessed externally through traitCollection.horizontalSizeClass for the latest value
    var horizontalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != horizontalSizeClass {
                horizontalSizeClassChanged(horizontalSizeClass)
            }
        }
    }

    /// Should be accessed externally through traitCollection.verticalSizeClass for the latest value
    var verticalSizeClass = UIUserInterfaceSizeClass.Unspecified {
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

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateSizes()
    }

    public override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateSizes()
    }

    public func horizontalSizeClassChanged(horizontalSizeClass: UIUserInterfaceSizeClass) {}
    public func verticalSizeClassChanged(verticalSizeClass: UIUserInterfaceSizeClass) {}

    public func updateContentContainerPadding() {
        sizeContentContainer().snp_updateConstraints(closure: { (make) in
            make.left.equalTo(view).offset(contentContainerSidePadding)
            make.right.equalTo(view).offset(-contentContainerSidePadding)
            make.top.equalTo(view).offset(contentContainerTopPadding)
            make.bottom.equalTo(view).offset(-contentContainerBottomPadding)
        })
    }
}
