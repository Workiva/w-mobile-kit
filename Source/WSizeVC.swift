//
//  WSizeVC.swift
//  Wdesk

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
