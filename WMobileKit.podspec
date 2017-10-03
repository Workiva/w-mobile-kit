#
# Be sure to run `pod lib lint WMobileKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'WMobileKit'
  s.version          = '5.1.0'
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
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = 'Source/*{h,m,swift}'
  s.dependency 'SnapKit', '3.2.0'
  s.dependency 'SDWebImage', '4.0.0'
end
