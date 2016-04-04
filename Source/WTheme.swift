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

    // General
    public var h1Color = UIColor.init(colorLiteralRed: 0.35, green: 0.858, blue: 0.54, alpha: 1)
    public var h2Color = UIColor.lightGrayColor()
    public var h3Color = UIColor.whiteColor()

    public var textColor = UIColor.whiteColor()

    public var primaryColor = UIColor.greenColor()

    public var tintColor = UIColor.whiteColor()

    // Specifics
    public var navigationColor: UIColor = UIColor.blueColor()
    public var pagingSelectorControlColor: UIColor = UIColor.lightGrayColor()
    public var pagingSelectionIndicatorColor: UIColor = UIColor.whiteColor()
}

public class GreenTheme: WTheme {
    public override init() {
        super.init()

        // Override colors here
        navigationColor = UIColor.init(hex: 0x42AD48)
        pagingSelectorControlColor = UIColor.init(hex: 0x6ABD5E)
    }
}

public class WThemeManager {
    public static func globalTheme(theme: WTheme) {
        customizePagingSelectorControl(theme)
        customizeNavigationBar(theme)
        customizeSideMenuVC(theme)
    }

    static func customizePagingSelectorControl(theme: WTheme) {
        WPagingSelectorControl.appearance().backgroundColor = theme.pagingSelectorControlColor
        WSelectionIndicatorView.appearance().backgroundColor = theme.pagingSelectionIndicatorColor
    }

    static func customizeNavigationBar(theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: theme.textColor]
        UINavigationBar.appearance().translucent = false
    }

    static func customizeSideMenuVC(theme: WTheme) {}
}
