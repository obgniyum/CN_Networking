#
# Be sure to run `pod lib lint CN_Networking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CN_Networking'
  s.version          = '0.2.0'
  s.summary          = 'A short description of CN_Networking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/obgniyum/CN_Networking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'obgniyum' => 'obgniyum@icloud.com' }
  s.source           = { :git => 'https://github.com/obgniyum/CN_Networking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CN_Networking/Classes/*.{h}'
  s.source_files = 'CN_Networking/Classes/**/*'
  
  s.subspec 'Network' do |s1|
      s1.source_files = 'CN_Networking/Classes/Network/*.{h,m}'
      s1.dependency 'AFNetworking'
  end
  
  s.subspec 'Float' do |s2|
      s2.source_files = 'CN_Networking/Classes/Float/*.{h,m}'
      s2.dependency 'CN_Networking/Network'
  end
  
  s.resource_bundles = {
      'CN_Networking' => ['CN_Networking/**/*.{md}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
end
