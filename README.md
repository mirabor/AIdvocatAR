# table of contents
- [huh? what is AIdvocatAR?](#huh?-what-is-AIdvocatAR?)
- [app demo](#app-demo)
- [notes for readability](#notes-for-readability)
- [how to run](#How-to-run)
- [how it's written](#How-it's-written)

# huh? what is AIdvocatAR?
AIdvocatAR (AI + advocate + AR) is an iOS app that currently uses a text-to-chat LLM to select AR models based on lines of prose/poetry that the user selects from the harvard advocate website, which is accessible in-app.

# app demo
(i was in the middle of the woods during this demo so the models take a minute to load, but it should work normally provided you're in civiization)
link to vid: https://drive.google.com/file/d/1enV_VjixWtJ7qvFkLogWlP97LUOyevoV/view?usp=sharing

# notes for readability
- i mainly use xcode's local git source control hence crazy commit history sorry
- started adding firebase but decided not to as of rn
- future plans:
    - make ui look cooler
    - connect to sanity to display advo website directly so users can just click on an article to input text
    - add sketchfab download api (https://sketchfab.com/developers/download-api) to access library of .usdz models and populate model picker view
    - use text-to-image api to generate uiimages for the .usdz models
    - add image to text recognition so users can point their camera at specific lines of text without copying/pasting from the site
    - publish to App Store for user access 


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
swiftui, arkit, focusentity, realitykit, safariservices, corcel api (shoutout mog!)


