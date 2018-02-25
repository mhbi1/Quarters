# Uncomment the next line to define a global platform for your project
platform :ios, '11.2'

target 'Quarters' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bettermint
pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'

pod 'TRCurrencyTextField', :git => 'https://github.com/thiagorossener/TRCurrencyTextField.git', :branch => 'master'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
