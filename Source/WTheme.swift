//
//  WTheme.swift
//  WMobileKit
//
//  WTheme works as a singleton that sets the appearance properties for 
//  w-mobile-kit components. The current theme should be set during the app delegate's
//  didFinishLaunchingWithOptions. Example:
//
//  let theme: WTheme = CustomTheme()
//  WThemeManager.sharedInstance.currentTheme = theme
//
//  For further customization a subclass of WTheme can be created and the color
//  values set to custom values. See Custom Theme for an example. 
//
//  Once the WThemeManager is created it will set the defaultTheme automatically
//  which can then be changed by setting the currentTheme. In this way, themes can
//  be dynamically changed.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

public class WTheme {
    public init(){}

    // Accessible Colors
    public var primaryTextColor: UIColor = UIColor.blackColor()
    public var secondaryTextColor: UIColor = UIColor.grayColor()

    // Colors that apply directly to theme

    // Paging Selector
    public var pagingSelectorControlColor: UIColor = UIColor.lightGrayColor()
    public var pagingSelectionIndicatorColor: UIColor = UIColor.whiteColor()

    // Navigation Bar
    public var navigationBarColor: UIColor = UIColor.blueColor()
    public var navigationTintColor: UIColor = UIColor.whiteColor()
    public var navigationTextColor: UIColor = UIColor.whiteColor()
}

// Theme with all default values
public class DefaultTheme: WTheme {}

public class GreenTheme: WTheme {
    public override init() {
        super.init()

        // Override colors here
        navigationBarColor = UIColor(hex: 0x42AD48)
        pagingSelectorControlColor = UIColor(hex: 0x6ABD5E)
    }
}

public class CustomTheme: WTheme {
    public override init() {
        super.init()

        // Override colors here
        navigationBarColor = UIColor(hex: 0x42AD48)

        pagingSelectorControlColor = UIColor.whiteColor()
        pagingSelectionIndicatorColor = UIColor(hex: 0x026DCE)

        primaryTextColor = UIColor(hex: 0x595959)
        secondaryTextColor = UIColor(hex: 0x595959)
    }
}

public class WThemeManager: NSObject {
    public static let sharedInstance = WThemeManager()

    private override init() {
        super.init()
        setTheme(currentTheme)
    }

    public var currentTheme: WTheme = DefaultTheme() {
        didSet {
            setTheme(currentTheme)
        }
    }

    private func setTheme(theme: WTheme) {
        customizePagingSelectorControl(theme)
        customizeNavigationBar(theme)
        customizeSideMenuVC(theme)
    }

    private func customizePagingSelectorControl(theme: WTheme) {
        WPagingSelectorControl.appearance().backgroundColor = theme.pagingSelectorControlColor
        WSelectionIndicatorView.appearance().backgroundColor = theme.pagingSelectionIndicatorColor
    }

    private func customizeNavigationBar(theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationBarColor
        UINavigationBar.appearance().tintColor = theme.navigationTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: theme.navigationTextColor]
    }

    private func customizeSideMenuVC(theme: WTheme) {}
}
