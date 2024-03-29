# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Marina Home' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marina Home
	pod 'IQKeyboardManager'
	pod 'SDWebImage'
	pod 'Alamofire'
  pod 'DropDown'
	
  	
	#google
  	pod 'GoogleSignIn'
  	pod 'GoogleSignInSwift'
    pod "PageControls/PillPageControl"
    #payment
    pod 'PhoneNumberKit', :git => 'https://github.com/marmelroy/PhoneNumberKit'
    pod 'Frames', '~> 4'
    #BottomSheet 
    pod 'UBottomSheet', :git => 'https://github.com/mmujassam/UBottomSheet'
     pod 'FSCalendar'
	pod 'GoogleMaps'
	pod 'GooglePlaces'
    pod "KlaviyoSwift", '~> 2.4.0'
  pod 'McPicker', '~> 3.0.0'
  pod 'NewRelicAgent'
  pod 'SkeletonView'
  pod "MediaSlideshow/Kingfisher", :path => "./"
  pod 'TTGTagCollectionView'
  
end

deployment_target = '14.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end

