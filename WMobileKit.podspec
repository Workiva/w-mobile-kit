#
# Be sure to run `pod lib lint WMobileKit.podspec' to ensure this is a
# valid spec before submitting.
#
Pod::Spec.new do |s|
  s.name             = "WMobileKit"
  s.version          = "0.0.1"
  s.summary          = "UI kit for iOS."

  s.homepage         = "https://app.wdesk.com"
  # s.homepage         = "https://github.com/Workiva/WMobileKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Workiva" => "https://github.com/Workiva" }
  s.source           = { :git => "https://github.com/Workiva/WMobileKit.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/*.swift'
  s.resource_bundles = {
    'WMobileKit' => ['Assets/*.png']
  }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
