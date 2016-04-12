//
//  WTheme.swift
//  WMobileKit

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

// TODO: Clearly define how the theme works with the app
public class WTheme {
    public init(){}

    // Accessible Colors
    public var primaryTextColor: UIColor = UIColor.blackColor()
    public var secondaryTextColor: UIColor = UIColor.grayColor()

    // Applies to theme

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

public class WThemeManager {
    public static let sharedInstance = WThemeManager()

    private init() {
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
