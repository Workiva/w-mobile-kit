# WMobileKit

[![CI Status](http://img.shields.io/travis/Workiva/WMobileKit.svg?style=flat)](https://travis-ci.org/Workiva/WMobileKit)
[![Version](https://img.shields.io/cocoapods/v/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![License](https://img.shields.io/cocoapods/l/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)
[![Platform](https://img.shields.io/cocoapods/p/WMobileKit.svg?style=flat)](http://cocoapods.org/pods/WMobileKit)

### Note:
This is intended to be a public repo in the future. Please keep all code and commit messages professional and clean so that the
process of going public is as smooth as possible!

## Usage

To run the example project, clone the repo, and run `pod install --repo-update` from the Example directory first.

`--repo-update` is required as there is a bug in the current cocoapods beta.

## Requirements
- You system must use the beta version of cocoapods (1.0.0.beta.5)
    - This can be installed using: `gem install cocoapods --pre`
    - If you are using a Gemfile, add the cocoapods beta
```ruby
gem "cocoapods", "1.0.0.beta.6"

DEPENDENCIES
    cocoapods (= 1.0.0.beta.6)
 ```
 - `use_frameworks!` must be at the top of your Podfile (since this is a Swift pod)

## Installation

WMobileKit is only available locally until it is ready for public consumption. To use,
clone this repo and follow the usage instructions and ensure the requirements are met.
Then, in your project, open your Podfile and add:

```ruby
pod 'WMobileKit', :path => '/<path>/w-mobile-kit/'
```

where the path is the path to the local w-mobile-kit repo.

If you are a Workiva User, use the relative path:

```ruby
pod 'WMobileKit', :path => '../../../../w-mobile-kit/'
```

Upon release:
WMobileKit will be available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WMobileKit"
```

### Known Issues

#### pod lib lint

Error:
 -> WMobileKit (0.0.1)
    - ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `--verbose` for more information.
    - NOTE  | [iOS] xcodebuild:  error: /Users/<username>/Library/Developer/Xcode/DerivedData/App-duleyrsezkvsavdltyhdceybcwgx/Build/Products/Release-iphonesimulator/WMobileKit/WMobileKit.bundle: No such file or directory

[!] WMobileKit did not pass validation, due to 1 error.
You can use the `--no-clean` option to inspect any issue.

There is a bug with cocoapods version 1.0.0.beta.6 that affects our build: https://github.com/CocoaPods/CocoaPods/issues/5034

Solution:
- Open the directory to the bundle file: /Users/<username>/Library/Developer/Xcode/DerivedData/App-duleyrsezkvsavdltyhdceybcwgx/Build/Products/Release-iphonesimulator/WMobileKit/
- Copy bundle to the directory above it and rerun.

#### use_frameworks missing

Error:
[!] Pods written in Swift can only be integrated as frameworks; this feature is still in beta. Add `use_frameworks!` to your Podfile or target to opt into using it. The Swift Pod being used is: WMobileKit
    Warning: Command failed:  Use --force to continue.

Solution:
- Add `use_frameworks` to the top of your Podfile

## Author

Workiva

## License

WMobileKit is available under the MIT license. See the LICENSE file for more info.
