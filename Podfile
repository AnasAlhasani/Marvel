platform :ios, '11.0'

target 'Marvel' do
  use_frameworks!
  pod 'CoreNetwork', :git => 'https://github.com/AnasAlhasani/CoreNetwork', :tag => 'v1.0.4'
  pod 'Kingfisher', '~> 5.0'
  pod 'SwiftLint'
  pod 'SwiftGen'
  pod 'CryptoSwift'
  pod 'RealmSwift', '~> 3.20.0'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
