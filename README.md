
# table of contents
- [app demo](#App-Demo)
- [how to Run](#How-to-Run)
- [how it's written](#How-it's-written)


# app demo


# how to run
- install XCode version 13 and have an iPhone X or later
- clone the repo
- Go to the project directory

*might add firebase components later but not rn. don't do the below if not using firebase!*

- (if firebase used) run the following command to create podfile
```bash
pod init
```
- open the podfile
```bash
open podfile
```
- copy and paste this to the podfile
```
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'advocAR' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  # Pods for AR-online-shopping-iOS

  target 'advocARTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'advocARUITests' do
    # Pods for testing
  end

#  pod 'FirebaseCore'
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


```

- install the dependencies to the podfile.
```bash
pod install
```
- open the .xcworkspace file and run


# how it's written
swiftui, arkit, focusentity, realitykit


