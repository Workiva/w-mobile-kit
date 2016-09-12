#
# Be sure to run `pod lib lint WMobileKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'WMobileKit'
  s.version          = '0.0.5'
  s.summary          = 'Swift library containing various custom UI components to provide functionality outside of the default libraries.'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.homepage         = 'https://github.com/Workiva/w-mobile-kit'
  s.authors          = { 'James Romo' => 'james.romo@workiva.com',
                         'Jordan Ross' => 'jordan.ross@workiva.com',
                         'Jeff Scaturro' => 'jeff.scaturro@workiva.com',
                         'Todd Tarbox' => 'todd.tarbox@workiva.com',
                         'Brian Blanchard' => 'brian.blanchard@workiva.com',
                         'Bryan Rezende' => 'bryan.rezende@workiva.com' }
  s.source           = { :git => 'https://github.com/Workiva/w-mobile-kit.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = 'Source/*{h,m,swift}'
  s.dependency 'SnapKit', '~> 0.22.0'
  s.dependency 'CryptoSwift', '~> 0.4'
  s.dependency 'SDWebImage', '3.8'
end
