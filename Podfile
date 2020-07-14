platform :ios, '10.0'
use_frameworks!

def common_pods
  pod 'SDWebImage', '5.8.3' #https://github.com/rs/SDWebImage
  pod 'SnapKit', '5.0.1' #https://github.com/SnapKit/SnapKit
end

target 'WMobileKit' do
  common_pods
end

target 'WMobileKitTests' do
  common_pods
  pod 'Nimble', '8.1.1' #https://github.com/Quick/Nimble
  pod 'Quick', '3.0.0' #https://github.com/Quick/Quick
end
