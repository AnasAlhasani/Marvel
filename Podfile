iOS_version = '12.0'
platform :ios, iOS_version

inhibit_all_warnings!

target 'Marvel' do
  use_frameworks!
  pod 'SwiftLint'
  pod 'SwiftGen'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = iOS_version
    end
  end
end
