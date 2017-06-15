platform :ios, '9.0'
use_frameworks!

def common_pods
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git', :commit => 'd31148f' #'3.2.0',
  pod 'SDWebImage', '4.0.0'
end

target 'WMobileKit' do
  common_pods
end

target 'WMobileKitTests' do
  common_pods
  pod 'Quick', '1.1.0'
  pod 'Nimble', '7.0.1'
end
