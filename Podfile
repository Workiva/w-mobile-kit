platform :ios, '9.0'
use_frameworks!

def common_pods
  pod 'Material', '2.10.2' #https://github.com/CosmicMind/Material
  pod 'SDWebImage', '4.0.0' #https://github.com/rs/SDWebImage
  pod 'SnapKit', '4.0.0' #https://github.com/SnapKit/SnapKit
end

target 'WMobileKit' do
  common_pods
end

target 'WMobileKitTests' do
  common_pods
  pod 'Nimble', '7.0.2' #https://github.com/Quick/Nimble
  pod 'Quick', '1.2.0' #https://github.com/Quick/Quick
end
