# WMobileKit

[![Version](https://img.shields.io/cocoapods/v/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![License](https://img.shields.io/cocoapods/l/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![Platform](https://img.shields.io/cocoapods/p/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59d266080dd7d400015d1a6f&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59d266080dd7d400015d1a6f/build/latest?branch=master)

WMobileKit is a Swift library containing various custom UI components to provide functionality outside of the default libraries. Each component is customizable and featured in a sample app to demonstrate its functionality!

### Index
* [Controls](#controls)
* [Information Views](#information-views)
* [Modal Components](#modal-components)
* [Navigation](#navigation)
* [Text Inputs](#text-inputs)
* [Miscellaneous/Utilities](#miscellaneousutilities)

## Features

### Controls
Component | Demo
--- | ---
<b>[WRadio](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WRadioButton.swift)</b><br> Web-like radio button that can be tied to a group and automatically select/deselect as expected from a normal radio button. The size and color of the outer and inner circle can be changed as well as the highlight. | <img src="Gifs/WSwitchWRadio.gif">
<b>[WSwitch](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WSwitch.swift)</b><br> Custom switch control emulating Apple's custom switches. Adds the ability to change sizes, colors, and sliding behaviors. | <img src="Gifs/WSwitchWRadio.gif">

### Information Views
Component | Demo
--- | ---
<b>[WBadge](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WBadge.swift)</b><br> Custom number badge that provides the ability to change color, spacing, shape, location, and how the number displays/expands. | <img src="Gifs/WBadge.gif">
<b>[WSpinner](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WSpinner.swift)</b><br> Custom progress spinner allowing for custom colors, the addition of images.  | <img src="Gifs/WSpinner.gif">
<b>[WUserLogoView](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WUserLogoView.swift)</b><br> An image used to represent a user. Can use either a name which is hashed into a color or and image that is cropped to fit the view. | <img src="Gifs/WUserLogoView.gif">
<b>[WAutoLayoutView](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WAutoViewLayoutVC.swift)</b><br> View that automatically adds as many of the provided views as possible to each row as determined by the controller's width and wraps to the next row for any remaining views while adjusting the height to fit the content. | <img src="Gifs/WAutoLayoutView.gif">

### Modal Components
Component | Demo
--- | ---
<b>[WActionSheet](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WActionSheet.swift)</b><br> Custom action sheets providing the ability to include a picker view, automatically scale to content, scroll, include a cancel button, and tap to dismiss. | <img src="Gifs/WActionSheet.gif">
<b>[WBanner](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WBanner.swift)</b><br>  Static banners that display information over content from the top or bottom. Can be automatically dismissed or on tap. | <img src="Gifs/WBanner.gif">
<b>[WLoadingModal](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WLoadingModal.swift)</b><br> Displays a loading view over content. Can dim the background view and will disappear after a set period of time. | <img src="Gifs/WLoadingModal.gif">
<b>[WToast](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WToast.swift)</b><br> Toast that displays from the top/bottom or sides and can be customized to dismiss on tap or via a timer. The color, text, and transparency can be customized. | <img src="Gifs/WToast.gif">

### Navigation
Component | Demo
--- | ---
<b>[WPagingSelectorControl](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WPagingSelectorVC.swift#L120)</b><br> Custom paging control that allows scrolling headers, automatically spaced headers and button actions to display a view controller. | <img src="Gifs/WPagingSelectorControl.gif">
<b>[WPagingSelectorVC](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WPagingSelectorVC.swift#L400)</b><br> View controller leveraging the WPagingSelectorControl. | <img src="Gifs/WPagingSelectorVC.gif">
<b>[WSideMenuVC](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WSideMenuVC.swift)</b><br> Custom side menu drawer. Displays view controllers as cells that can be tapped to swap the main view. | <img src="Gifs/WSideMenuVC.gif">

### Text Inputs
Component | Demo
--- | ---
<b>[WAutoCompleteTextView](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WAutoCompleteTextView.swift)</b><br> Text view that provides suggestions as you type. | <img src="Gifs/WAutoCompleteTextView.gif">
<b>[WMarkdownTextView](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WTextView.swift#L203)</b><br> Text view that interprets and displays markdown text. | <img src="Gifs/WMarkdownTextView.gif">
<b>[WTextField](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WTextField.swift)</b><br> UITextField with expanded functionality. | <img src="Gifs/WTextField.gif">
<b>[WTextView](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WTextView.swift)</b><br> UITextView with expanded functionality. | <img src="Gifs/WTextView.gif">

### Miscellaneous/Utilities
Component | Description
--- | ---
<b>[WSizeVC](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WSizeVC.swift)</b><br> | Base view controller that responds to and sends size change related events. Supports iPad Pro/Air split views.  
<b>[WTheme](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WTheme.swift)</b><br> | Component that allows for simple theme creation that can be used throughout an app.  
<b>[WUtils](https://github.com/Workiva/w-mobile-kit/blob/master/Source/WUtils.swift)</b><br> | Random useful methods.  

## Usage

To use the library in your app, add the following import to your file:
```swift
import WMobileKit
```

To run the example project, run `./setup.sh` in the root directory.
Alternatively, you can run `pod install` from the Example directory.

## Requirements

 - `use_frameworks!` must be at the top of your Podfile (since this is a Swift pod)
 - iOS 8.0+
 - Xcode 9.0
 - Objective-C, Swift 3.2

## Installation

Add the following to your Podfile:
```ruby
pod "WMobileKit"
```

## Sample App Setup

Run the following in the root directory
```ruby
./setup.sh
```

## Contributions

A release is automatically created with each pull request. Please bump the WMobileKit.podspec,
Source/Info.plist, and Example/WMobileKitExample/Info.plist using ```version_bump.sh```
according to semantic versioning.

Example: (5.1.0 is the old version 5.1.1 is the new version)
```ruby
./version_bump.sh 5.1.0 5.1.1
```

### Known Issues

#### use_frameworks missing

Error:
```ruby
[!] Pods written in Swift can only be integrated as frameworks; this feature is still in beta. Add `use_frameworks!` to your Podfile or target to opt into using it. The Swift Pod being used is: WMobileKit
    Warning: Command failed:  Use --force to continue.
```

Solution:
- Add `use_frameworks` to the top of your Podfile

## License

WMobileKit is available under the Apache license. See the LICENSE file for more info.

## Authors
- James Romo
- Jordan Ross
- Jeff Scaturro
- Todd Tarbox
- Brian Blanchard
- Bryan Rezende
