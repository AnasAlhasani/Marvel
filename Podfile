iOS_version = '12.0'
platform :ios, iOS_version

inhibit_all_warnings!
use_frameworks!

workspace 'Marvel.xcworkspace'

## Pods

def toolsPods
    pod 'SwiftLint'
    pod 'SwiftGen'
    pod 'SwiftFormat/CLI'
end

## Application

target 'Marvel' do
  project 'Marvel.project'
  toolsPods
  
  target 'MarvelTests' do
    inherit! :search_paths
  end
end

## Helpers

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = iOS_version
    end
  end
end
