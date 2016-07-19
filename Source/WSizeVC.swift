//
//  WSizeVC.swift
//  Wdesk

import UIKit
import Foundation

public class WSizeVC: UIViewController {
    var horizontalSizeClass = UIUserInterfaceSizeClass.Unspecified {
        didSet {
            if oldValue != horizontalSizeClass {
                horizontalSizeClassChanged(horizontalSizeClass)
            }
        }
    }

    var verticalSizeClass = UIUserInterfaceSizeClass.Unspecified {
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

    func horizontalSizeClassChanged(horizontalSizeClass: UIUserInterfaceSizeClass) { }
    func verticalSizeClassChanged(verticalSizeClass: UIUserInterfaceSizeClass) { }
}
