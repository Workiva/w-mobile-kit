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
//  Copyright 2017 Workiva Inc.
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

open class WTheme: NSObject {
    public override init(){}

    // Accessible Colors
    open var primaryTextColor: UIColor = .black
    open var secondaryTextColor: UIColor = .gray

    // Colors that apply directly to theme
    open var backgroundColor: UIColor = UIColor(hex: 0x32B0CA) // teal

    // Paging Selector
    open var pagingSelectorControlColor: UIColor = .lightGray
    open var pagingSelectionIndicatorColor: UIColor = .white
    open var pagingSelectorSeparatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
    
    // Action Sheet
    open var actionSheetSelectColor: UIColor = .blue

    // Navigation Bar
    open var navigationBarColor: UIColor = .blue
    open var navigationTintColor: UIColor = .white
    open var navigationTextColor: UIColor = .white
    
    // Toast
    open var toastBGColor: UIColor = .green
    
    // Switch
    open var switchOutlineColor: UIColor = .blue
    open var switchBarColor: UIColor = .blue

    // Loading Modal
    open var loadingModalBackgroundColor: UIColor = .clear
}

// Theme with all default values
open class DefaultTheme: WTheme {}

open class GreenTheme: WTheme {
    public override init() {
        super.init()

        // Override colors here
        navigationBarColor = UIColor(hex: 0x42AD48)
        pagingSelectorControlColor = UIColor(hex: 0x6ABD5E)
    }
}

open class CustomTheme: WTheme {
    public override init() {
        super.init()

        // Override colors here
        navigationBarColor = UIColor(hex: 0x1F82A6)

        pagingSelectorControlColor = UIColor(hex: 0x2495BE)
        pagingSelectionIndicatorColor = UIColor(hex: 0x026DCE)
        pagingSelectorSeparatorColor = UIColor(hex: 0xDEDEDE, alpha: 0.35)
        
        actionSheetSelectColor = UIColor(hex: 0x0094FF)

        primaryTextColor = UIColor(hex: 0x2DBBEE)
        secondaryTextColor = UIColor(hex: 0xFFFFFF)
        toastBGColor = UIColor(hex: 0x42AD48)
        
        switchOutlineColor = UIColor(hex: 0xBFE4FF)
        switchBarColor = UIColor(hex: 0xBFE4FF)
    }
}

open class WThemeManager: NSObject {
    public static let sharedInstance = WThemeManager()

    fileprivate override init() {
        super.init()
        setTheme(currentTheme)
    }

    open var currentTheme: WTheme = DefaultTheme() {
        didSet {
            setTheme(currentTheme)
        }
    }

    fileprivate func setTheme(_ theme: WTheme) {
        customizePagingSelectorControl(theme)
        customizeActionSheet(theme)
        customizeNavigationBar(theme)
        customizeSideMenuVC(theme)
        customizeToast(theme)
        customizeSwitch(theme)
    }

    fileprivate func customizePagingSelectorControl(_ theme: WTheme) {
        WPagingSelectorControl.appearance().backgroundColor = theme.pagingSelectorControlColor
        WSelectionIndicatorView.appearance().backgroundColor = theme.pagingSelectionIndicatorColor
    }
    
    fileprivate func customizeActionSheet(_ theme: WTheme) {
        WSelectBar.appearance().backgroundColor = theme.actionSheetSelectColor
    }

    fileprivate func customizeNavigationBar(_ theme: WTheme) {
        UINavigationBar.appearance().barTintColor = theme.navigationBarColor
        UINavigationBar.appearance().tintColor = theme.navigationTintColor
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: theme.navigationTextColor])

        // Needed for views to not show behind the nav bar
        UINavigationBar.appearance().isTranslucent = false
    }
    
    fileprivate func customizeToast(_ theme: WTheme) {
        WToastView.appearance().backgroundColor = theme.toastBGColor
    }
    
    fileprivate func customizeSwitch(_ theme: WTheme) {
        WSwitchOutlineCircleView.appearance().backgroundColor = theme.switchOutlineColor
        WSwitchBarView.appearance().backgroundColor = theme.switchBarColor
    }

    fileprivate func customizeSideMenuVC(_ theme: WTheme) {}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
