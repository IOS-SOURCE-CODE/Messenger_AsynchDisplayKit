platform :ios, '9.0'

target 'MessengerUI' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MessengerUI
  pod 'AsyncDisplayKit', '>= 2.0'
  pod 'ALTextInputBar'
  pod 'Google/SignIn'
  pod 'IQKeyboardManagerSwift'
  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'RealmSwift'
  pod 'Socket.IO-Client-Swift', '~> 8.3.3'
  pod 'KSTokenView', '~> 3.1'
  
  target 'MessengerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MessengerUIUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end



