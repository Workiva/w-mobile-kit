platform :ios, '9.0'
use_frameworks!

def common_pods
#  pod 'Material', '2.10.2' #https://github.com/CosmicMind/Material
  pod 'SDWebImage', '4.0.0' #https://github.com/rs/SDWebImage
  pod 'SnapKit', '3.2.0' #https://github.com/SnapKit/SnapKit
end

target 'WMobileKit' do
  common_pods
end

target 'WMobileKitTests' do
  common_pods
  pod 'Nimble', '7.0.2' #https://github.com/Quick/Nimble
  pod 'Quick', '1.2.0' #https://github.com/Quick/Quick
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      if target.name == 'Material'
#        config.build_settings['SWIFT_VERSION'] = '3.2'
#      end
#      if target.name == 'SnapKit'
#        config.build_settings['SWIFT_VERSION'] = '3.2'
#      end
#    end
#  end
#end

