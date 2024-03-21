project 'advocAR.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'advocAR' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  target 'advocARTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'advocARUITests' do
    # Pods for testing
  end

  pod 'FirebaseCore'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'SDWebImageSwiftUI'
#  pod 'leveldb-library'
#  pod 'nanopb'


  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
end

