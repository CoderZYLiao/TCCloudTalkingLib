#
# Be sure to run `pod lib lint TCCloudTalking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    #库名称
    s.name             = 'TCCloudTalking'
    #版本号
    s.version          = '1.0.4.4'
    #库简短介绍
    s.summary          = '云对讲组件'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    #开源库描述
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    #开源库地址，或者是博客、社交地址等
    s.homepage         = 'http://10.10.5.215:7880/iosteam/TCCloudTalking'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    #开源协议
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    #开源库作者
    s.author           = { 'TYL' => 'tianyalin@taichuan.com' }
    #开源库GitHub的路径与tag值，GitHub路径后必须有.git,tag实际就是上面的版本
    s.source           = { :git => 'http://10.10.5.215:7880/iosteam/TCCloudTalking.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    #开源库最低支持
    s.ios.deployment_target = '9.0'
    #源库资源文件
    s.source_files = 'TCCloudTalking/Classes/**/*'
    
    # s.resource_bundles = {
    #   'TCCloudTalking' => ['TCCloudTalking/Assets/*.png']
    # }
    
    #  s.public_header_files = 'TCCloudTalking/Classes/Header/Header.h'
    # s.dependency 'AFNetworking', '~> 2.3'
    #是否支持arc
    s.requires_arc = true
    
    #依赖系统库
    
    
    #开源库依赖库
    
    s.dependency 'TCMember'
    s.dependency 'TCPublicKit'
    s.dependency 'FMDB', '~> 2.6.2'
    s.dependency 'Masonry'
    s.dependency 'MJRefresh'
    s.dependency 'MJExtension'
    s.dependency 'SDWebImage'
    s.dependency 'pop', '~> 1.0.9'
    s.dependency 'DZNEmptyDataSet'
    s.dependency 'SVProgressHUD'
    s.dependency 'SGQRCode'
    s.dependency 'JPush'
    
    #依赖的系统框架
    s.frameworks = 'Foundation','UIKit','MapKit','VideoToolbox','CoreGraphics','AssetsLibrary','AddressBookUI','MapKit','CoreAudio','AudioToolbox','CFNetwork','SystemConfiguration','MobileCoreServices','StoreKit','CoreLocation','CoreTelephony','AVFoundation','MediaPlayer','CoreMedia','CoreFoundation','MessageUI','AddressBook','Contacts','AddressBook','QuartzCore'
    #添加系统依赖静态库
    s.library = 'resolv','sqlite3.0','z', 'stdc++.6','stdc++','c++'
    
    #添加依赖第三方的framework
    s.vendored_frameworks = 'TCCloudTalking/Classes/iFLYOSsdk/*.framework'
    
    #静态库.a
    s.vendored_library = 'TCCloudTalking/Classes/VOIPSDK/*.a','TCCloudTalking/Classes/TCPSDK/*.a'
    
    #添加资源文件
    #s.resource = 'XXX/XXXX/**/*.bundle'
    #资源文件的路径，图片、音频等
    s.resource_bundles = {
        'TCCloudTalking' => ['TCCloudTalking/Assets/*.png','TCCloudTalking/Assets/*']
    }
    #在 podspec 文件中添加 s.static_framework = true，CocoaPods 就会把这个库配置成static framework。同时支持 Swift 和 Objective-C
    #s.static_framework = true
    
    #设置此处将在 模拟器编译时不产生二进制文件
    s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
    
end
