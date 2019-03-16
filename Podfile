platform :ios, '10.0'

target 'OurPet' do
use_frameworks!
    pod 'Firebase/Core'
    pod 'Firebase/Storage'
    pod 'Firebase/Firestore'
    pod 'Firebase/DynamicLinks'
    pod 'FirebaseUI'
    pod 'AlertOnboarding'
    pod 'LGButton', '1.0.5'
    pod 'WXImageCompress', '~> 0.1.1'
    pod 'OneSignal', '>= 2.5.2', '< 3.0'
    pod 'SCLAlertView' 
    pod 'CropViewController'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
end

target 'OneSignalNotificationServiceExtension' do
use_frameworks!
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
end