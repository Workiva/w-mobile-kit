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
    public convenience init(hex: Int, alpha: Double = 1) {
        self.init(
            red:   CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue:  CGFloat((hex >> 00) & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}

public class WTheme: NSObject {
    public override init(){}

    // Accessible Colors
    public var primaryTextColor: UIColor = .blackColor()
    public var secondaryTextColor: UIColor = .grayColor()

    // Colors that apply directly to theme
    public var backgroundColor: UIColor = UIColor(hex: 0x32B0CA) // teal

    // Paging Selector
    public var pagingSelectorControlColor: UIColor = .lightGrayColor()
    public var pagingSelectionIndicatorColor: UIColor = .whiteColor()
    
    // Action Sheet
    public var actionSheetSelectColor: UIColor = .blueColor()

    // Navigation Bar
    public var navigationBarColor: UIColor = .blueColor()
    public var navigationTintColor: UIColor = .whiteColor()
    public var navigationTextColor: UIColor = .whiteColor()
    
    // Toast
    public var toastBGColor: UIColor = .greenColor()
    
    // Switch
    public var switchOutlineColor: UIColor = .blueColor()
    public var switchBarColor: UIColor = .blueColor()

    // Loading Modal
    public var loadingModalBackgroundColor: UIColor = UIColor(hex: 0x595959, alpha: 0.85)
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
        navigationBarColor = UIColor(hex: 0x1F82A6)

        pagingSelectorControlColor = UIColor(hex: 0x2495BE)
        pagingSelectionIndicatorColor = UIColor(hex: 0x026DCE)
        
        actionSheetSelectColor = UIColor(hex: 0x0094FF)

        primaryTextColor = UIColor(hex: 0x2DBBEE)
        secondaryTextColor = UIColor(hex: 0xFFFFFF)
        toastBGColor = UIColor(hex: 0x42AD48)
        
        switchOutlineColor = UIColor(hex: 0xBFE4FF)
        switchBarColor = UIColor(hex: 0xBFE4FF)
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
        customizeActionSheet(theme)
        customizeNavigationBar(theme)
        customizeSideMenuVC(theme)
        customizeToast(theme)
        customizeSwitch(theme)
    }

    private func customizePagingSelectorControl(theme: WTheme) {
        WPagingSelectorControl.appearance().backgroundColor = theme.pagingSelectorControlColor
        WSelectionIndicatorView.appearance().backgroundColor = theme.pagingSelectionIndicatorColor
    }
    
    private func customizeActionSheet(theme: WTheme) {
        WSelectBar.appearance().backgroundColor = theme.actionSheetSelectColor
    }

    private func customizeNavigationBar(theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationBarColor
        UINavigationBar.appearance().tintColor = theme.navigationTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: theme.navigationTextColor]

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().translucent = false
    }
    
    private func customizeToast(theme: WTheme) {
        WToastView.appearance().backgroundColor = theme.toastBGColor
    }
    
    private func customizeSwitch(theme: WTheme) {
        WSwitchOutlineCircleView.appearance().backgroundColor = theme.switchOutlineColor
        WSwitchBarView.appearance().backgroundColor = theme.switchBarColor
    }

    private func customizeSideMenuVC(theme: WTheme) {}
}
