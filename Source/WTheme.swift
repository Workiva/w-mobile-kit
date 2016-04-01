////
////  WTheme.swift
////  WMobileKit
//
//import Foundation
//
//protocol WThemeProtocol: class {
//    func setTheme(theme: WTheme)
//    func updateUI()
//
//    var globalTheme: WTheme { get set }
//}
//
//extension WThemeProtocol {
//    //    func updateUI(){
//    //        theme.loadTheme()
//    //    }
//
//    var globalTheme: WTheme {
//        get {
//            return theme
//        }
//        set (newTheme) {
//            let defaults = NSUserDefaults.standardUserDefaults()
//            defaults.setObject("Solid Blue", forKey: "Theme")
////            theme = newTheme
//            WTheme.loadTheme()
//        }
//    }
//}
//
//public struct WTheme {
//    static let availableThemes = ["Solid Blue", "Pretty Pink", "Zen Black", "Light Blue", "Dark Blue", "Dark Green", "Dark Orange"]
//    public static func loadTheme() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let name = defaults.stringForKey("Theme"){
//            // Select the Theme
//            if name == "Solid Blue"		{ themeBlue() }
//            if name == "Pretty Pink" 	{ themeBlue() }
//            if name == "Zen Black" 		{ themeBlue() }
//            if name == "Light Blue" 	{ themeBlue() }
//            if name == "Dark Blue" 		{ themeBlue() }
//            if name == "Dark Green" 	{ themeBlue() }
//            if name == "Dark Orange" 	{ themeBlue() }
//        } else {
//            defaults.setObject("Solid Blue", forKey: "Theme")
//            themeBlue()
//        }
//    }
//
//    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
//    static var sectionHeaderTitleColor = UIColor.whiteColor()
//    static var sectionHeaderBackgroundColor = UIColor.blackColor()
//    static var sectionHeaderBackgroundColorHighlighted = UIColor.grayColor()
//    static var sectionHeaderAlpha: CGFloat = 1.0
//
//    // MARK: Blue Color Schemes
//    static func themeBlue() {
//        // MARK: ToDo Table Section Headers
//        sectionHeaderTitleFont = UIFont(name: "Helvetica", size: 18)
//        sectionHeaderTitleColor = UIColor.whiteColor()
//        sectionHeaderBackgroundColor = UIColor.blueColor()
//        sectionHeaderBackgroundColorHighlighted = UIColor.lightGrayColor()
//        sectionHeaderAlpha = 0.8
//    }
//
//    // MARK: Blue Color Schemes
//    static func customTheme() {
//        // MARK: ToDo Table Section Headers
//        sectionHeaderTitleFont = UIFont(name: "Helvetica", size: 18)
//        sectionHeaderTitleColor = UIColor.whiteColor()
//        sectionHeaderBackgroundColor = UIColor.blueColor()
//        sectionHeaderBackgroundColorHighlighted = UIColor.lightGrayColor()
//        sectionHeaderAlpha = 0.8
//    }
//}
//
//extension WTheme {
//    static func customTheme() {
//        // MARK: ToDo Table Section Headers
//        sectionHeaderTitleFont = UIFont(name: "Helvetica", size: 18)
//        sectionHeaderTitleColor = UIColor.whiteColor()
//        sectionHeaderBackgroundColor = UIColor.blueColor()
//        sectionHeaderBackgroundColorHighlighted = UIColor.lightGrayColor()
//        sectionHeaderAlpha = 0.8
//    }
//}

import Foundation
import UIKit

public class WTheme {
    public init(){}

    var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    var sectionHeaderTitleColor = UIColor.whiteColor()
    var sectionHeaderBackgroundColor = UIColor.blackColor()
    var sectionHeaderBackgroundColorHighlighted = UIColor.grayColor()
    var sectionHeaderAlpha: CGFloat = 1.0

    var h1Color: UIColor = UIColor.init(colorLiteralRed: 0.35, green: 0.858, blue: 0.54, alpha: 1)
    var h2Color = UIColor.lightGrayColor()
    var h3Color = UIColor.whiteColor()

    var primaryColor = UIColor.greenColor()
    var navigationColor = UIColor.blackColor()
    var tintColor = UIColor.whiteColor()
}

public class GreenTheme: WTheme {
    public override init() {
        super.init()
    }
}

public class WThemeManager {
    public static func globalTheme(theme: WTheme) {
        customizePagingVC(theme)
        customizeNavigationBar(theme)
    }

    static func customizePagingVC(theme: WTheme) {
        WTabLayout.appearance().backgroundColor = theme.h1Color
    }

    static func customizeNavigationBar(theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false
//        UINavigationBar.appearance().barTintColor = theme.navigationColor
//        UINavigationBar.appearance().barTintColor = theme.navigationColor


//        navigationBar.barTintColor = UIColor.blackColor()
//        navigationBar.tintColor = UIColor.whiteColor()
//        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        navigationBar.translucent = false
    }
}

//public struct WTheme {
//    public func globalTheme(primaryColor: UIColor) {
//        UIControl.appearanceWhenContainedWithin([WTabLayout.self]).backgroundColor = primaryColor
//    }
//
//    public func setGlobalTheme(primaryColor: UIColor) {
//        UIControl.appearanceWhenContainedWithin([WTabLayout.self]).backgroundColor = primaryColor
//    }

//    + (void)setGlobalThemeUsingPrimaryColor:(UIColor *)primaryColor
//    withContentStyle:(UIContentStyle)contentStyle {
//
//    if (contentStyle == UIContentStyleContrast) {
//
//    if ([ContrastColor(primaryColor, YES) isEqual:FlatWhite]) {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    } else {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
//
//    } else if (contentStyle == UIContentStyleLight) {
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
//    } else {
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
//
//    [[self class] customizeBarButtonItemWithPrimaryColor:primaryColor contentStyle:contentStyle];
//    [[self class] customizeButtonWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeNavigationBarWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizePageControlWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeProgressViewWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeSearchBarWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeSegmentedControlWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeSliderWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeStepperWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeSwitchWithPrimaryColor:primaryColor];
//    [[self class] customizeTabBarWithBarTintColor:FlatWhite andTintColor:primaryColor];
//    [[self class] customizeToolbarWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    [[self class] customizeImagePickerControllerWithPrimaryColor:primaryColor withContentStyle:contentStyle];
//    }
//}