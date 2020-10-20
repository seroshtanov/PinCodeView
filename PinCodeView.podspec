#
# Be sure to run `pod lib lint PinCodeView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PinCodeView'
  s.version          = '1.0.0'
  s.summary          = 'Customizable view to imput pin-code in iOS app'
  
  s.description      = <<-DESC
    Customizable view to imput pin-code. Supported auto-filling from sms
                       DESC

  s.homepage         = 'https://github.com/seroshtanov/PinCodeView.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '3422983@gmail.com' => '3422983@gmail.com' }
  s.source           = { :git => 'https://github.com/seroshtanov/PinCodeView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'PinCodeView/Classes/**/*'

end
