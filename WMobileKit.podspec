#
# Be sure to run `pod lib lint WMobileKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'WMobileKit'
  s.version          = '0.0.3'
  s.summary          = 'UI kit for common Swift components.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage         = 'https:app.wdesk.com'
#  s.homepage         = 'https://github.com/Workiva/w-mobile-kit'
  s.author           = { 'Workiva' => 'https://github.com/Workiva' }
  s.source           = { :git => 'https://github.com/Workiva/w-mobile-kit.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = 'Source/*{h,m,swift}'
  s.dependency 'SnapKit', '~> 0.20.0'
  s.dependency 'CryptoSwift', '~> 0.4'
  s.dependency 'SDWebImage', '3.8'
end
