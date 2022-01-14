source 'https://github.com/CocoaPods/Specs.git'

iOS_version = '12.0'
platform :ios, iOS_version

inhibit_all_warnings!
use_frameworks!

workspace 'Marvel.xcworkspace'

## Scripts 

def scripts
  script_phase :name => 'GitHooks', :script => "$SRCROOT/Settings/GitHooks/install.sh"
  script_phase :name => 'SwiftLint', :script => "$SRCROOT/Settings/SwiftLint/lint.sh"
  script_phase :name => 'SwiftGen', :script => "$SRCROOT/Settings/SwiftGen/generate.sh"
end

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
  scripts
  
  target 'MarvelTests' do
    inherit! :search_paths
  end
end

## Post Install

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = iOS_version
    end
  end
end
