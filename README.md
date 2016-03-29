# WMobileKit

[![CI Status](http://img.shields.io/travis/James Romo/WMobileKit.svg?style=flat)](https://travis-ci.org/James Romo/WMobileKit)
[![Version](https://img.shields.io/cocoapods/v/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![License](https://img.shields.io/cocoapods/l/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![Platform](https://img.shields.io/cocoapods/p/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)

## Usage

To run the example project, clone the repo, and run `pod install --repo-update` from the Example directory first.

### Note

Error:
pod lib lint

 -> WMobileKit (0.0.1)
    - ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `--verbose` for more information.
    - NOTE  | [iOS] xcodebuild:  error: /Users/jamesromo/Library/Developer/Xcode/DerivedData/App-duleyrsezkvsavdltyhdceybcwgx/Build/Products/Release-iphonesimulator/WMobileKit/WMobileKit.bundle: No such file or directory

[!] WMobileKit did not pass validation, due to 1 error.
You can use the `--no-clean` option to inspect any issue.

There is a bug with cocoapods version 1.0.0.beta.6 that affects our build: https://github.com/CocoaPods/CocoaPods/issues/5034

To fix:

open /Users/jamesromo/Library/Developer/Xcode/DerivedData/App-duleyrsezkvsavdltyhdceybcwgx/Build/Products/Release-iphonesimulator/WMobileKit/

copy bundle to the directory above it and rerun.

## Requirements

## Installation

WMobileKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WMobileKit"
```

## Author

Workiva

## License

WMobileKit is available under the MIT license. See the LICENSE file for more info.
