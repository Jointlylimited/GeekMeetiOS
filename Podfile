
target 'GeekMeets' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Basecode
  pod 'Moya'
  pod 'SwiftyJSON'
  pod 'ReachabilitySwift'

  pod 'IQKeyboardManagerSwift'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'GoogleSignIn'
  
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Crashlytics'
  # Recommended: Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  
#  pod 'JSONModel'
  pod 'SnapSDK'
  pod 'ActiveLabel'
  pod 'NVActivityIndicatorView'
  
  #  Amazon S3 Bucket for file upload
  pod 'AWSS3'
  pod 'AWSCognito'
  
  #  images manage
  pod 'Kingfisher'
  pod 'SDWebImage'
  
  #  Animation
  pod 'lottie-ios'
  
  # XMPP
   pod 'XMPPFramework/Swift'
   pod 'RSKGrowingTextView'
   pod 'OpalImagePicker'
   pod 'SwiftMessages', '7.0.0'
   
   # In-App
   pod 'SwiftyStoreKit'
   pod 'CropPickerView'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
