# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'UnderTheWeather' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UnderTheWeather
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
    pod 'SwiftyJSON', '2.4.0'
    pod 'MBProgressHUD', '~> 1.0.0'

  target 'UnderTheWeatherTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UnderTheWeatherUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = "2.3"
        end
    end
end
