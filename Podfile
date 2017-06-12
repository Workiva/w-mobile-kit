platform :ios, '9.0'
use_frameworks!

def common_pods
  pod 'SnapKit', '3.2.0'
  pod 'SDWebImage', '4.0.0'
  pod 'Material', '2.6.3' #https://github.com/CosmicMind/Material
end

target 'WMobileKit' do
  common_pods
end

target 'WMobileKitTests' do
  common_pods
  pod 'Quick', '1.1.0'
  pod 'Nimble', '6.0.1'
end
