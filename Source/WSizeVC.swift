//
//  WSizeVC.swift
//  Wdesk

import UIKit
import Foundation

public class WSizeVC: UIViewController {
    public func isIPadSize() -> Bool {
        return (horizontalSizeClass == .Compact) ? false : true
    }

    // Should be accessed externally through traitCollection.horizontalSizeClass for the latest value
    public private(set) var horizontalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != horizontalSizeClass {
                horizontalSizeClassChanged(horizontalSizeClass)
            }
        }
    }

    public private(set) var verticalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != verticalSizeClass {
                verticalSizeClassChanged(verticalSizeClass)
            }

            verticalSizeClassChanged(verticalSizeClass)
        }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        horizontalSizeClass = traitCollection.horizontalSizeClass
        verticalSizeClass = traitCollection.verticalSizeClass
    }

    public override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        horizontalSizeClass = traitCollection.horizontalSizeClass
        verticalSizeClass = traitCollection.verticalSizeClass
    }

    public func horizontalSizeClassChanged(horizontalSizeClass: UIUserInterfaceSizeClass) { }
    public func verticalSizeClassChanged(verticalSizeClass: UIUserInterfaceSizeClass) { }
}
