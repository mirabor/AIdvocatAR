
# Table of contents
- [App Demo](#App-Demo)
- [How to Run](#How-to-Run)
- [Context](#Context)
- [Content](#Content)
- [How it's written](#How-it's-written)


# App Demo


# How to Run
First make sure to install XCode version 13 or later and have iPhone X or later versions.

Clone the repository:

Go to the project directory.

Next, run the following command to create podfile.
```bash
pod init
```

Open the podfile by the following command to add the dependencies.
```bash
open podfile
```

Copy and paste the follwing text to the podfile


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

Run the following command to install the dependencies to the podfile.
```bash
pod install
```
Finally, open the xcworkspace file using the Xcode. Connect your iphone to your MacBook and run the code :)

# Context

# Content

# How it's written
The front-end was implemented using SwiftUI, ARKit, MessageUI, and FocusEntity. The User Authentication and Cloud Stroge was developed using Google Firebase.


