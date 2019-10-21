#
# Be sure to run `pod lib lint TCCloudTalking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCCloudTalking'
  s.version          = '1.0.0'
  s.summary          = '云对讲组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://10.10.5.215:7880/iosteam/TCCloudTalking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TYL' => 'tianyalin@taichuan.com' }
  s.source           = { :git => 'http://10.10.5.215:7880/iosteam/TCCloudTalking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TCCloudTalking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TCCloudTalking' => ['TCCloudTalking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation','UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
