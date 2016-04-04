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

public class WTheme {
    public init(){}

//    var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
//    var sectionHeaderTitleColor = UIColor.whiteColor()
//    var sectionHeaderBackgroundColor = UIColor.blackColor()
//    var sectionHeaderBackgroundColorHighlighted = UIColor.grayColor()
//    var sectionHeaderAlpha: CGFloat = 1.0

    var h1Color: UIColor = UIColor.init(colorLiteralRed: 0.35, green: 0.858, blue: 0.54, alpha: 1)
    var h2Color = UIColor.lightGrayColor()
    var h3Color = UIColor.whiteColor()

    var primaryColor = UIColor.greenColor()
    public var navigationColor = UIColor.blueColor()
    var tintColor = UIColor.whiteColor()


    var pagingSelectorBackgorundColor = UIColor.init(hex: 0x6ABD5E)
//    var mainNavigationBackgorundColor = UIColor.init(hex: 0x42AD48)
}

public class GreenTheme: WTheme {
    public override init() {
        super.init()

        navigationColor = UIColor.init(hex: 0x42AD48)
    }
}

public class WThemeManager {
    public static func globalTheme(theme: WTheme) {
        customizePagingSelectorVC(theme)
        customizeNavigationBar(theme)

    }

    static func customizePagingSelectorVC(theme: WTheme) {
        WPagingSelectorVC.appearance().backgroundColor = theme.pagingSelectorBackgorundColor
        WSelectionIndicatorView.appearance().backgroundColor = UIColor.whiteColor()
    }

    static func customizeNavigationBar(theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false
    }

    static func customizeSideMenuVC(theme: WTheme) {
        
    }
}
