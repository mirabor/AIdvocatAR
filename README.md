# table of contents
- [app demo](#App-Demo)
- [notes for readability](#notes-for-readability)
- [how to run](#How-to-run)
- [how it's written](#How-it's-written)


# app demo


# notes for readability
- i mainly use xcode's local git source control hence crazy commit history sorry
- started adding firebase but decided not to as of rn
- future plans:
    - add sketchfab download api (https://sketchfab.com/developers/download-api) to access library of .usdz models and populate model picker view
    - add image to text recognition so users can point their camera at specific lines of text without copying/pasting from the site


# how to run
- have XCode at least version 13
- have iPhone X or later
- have usb—usb-c cord 
- clone the repo
- plug in and build 

*might add backend  later but firebase is currently not implememented. don't do the below steps if not using firebase!*
- go to the project directory
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
swiftui, arkit, focusentity, realitykit, safariservices


