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

public class WSizeVC: UIViewController {
    // Must be checked on view will appear or later for accurate result
    public func isIPadSize() -> Bool {
        return ((traitCollection.horizontalSizeClass == .Compact) || (traitCollection.verticalSizeClass == .Compact)) ? false : true
    }

    // Should be accessed externally through traitCollection.horizontalSizeClass for the latest value
    var horizontalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != horizontalSizeClass {
                horizontalSizeClassChanged(horizontalSizeClass)
            }
        }
    }

    // Should be accessed externally through traitCollection.verticalSizeClass for the latest value
    var verticalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != verticalSizeClass {
                verticalSizeClassChanged(verticalSizeClass)
            }

            verticalSizeClassChanged(verticalSizeClass)
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

    public func horizontalSizeClassChanged(horizontalSizeClass: UIUserInterfaceSizeClass) { }
    public func verticalSizeClassChanged(verticalSizeClass: UIUserInterfaceSizeClass) { }
}
