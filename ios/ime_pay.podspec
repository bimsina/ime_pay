#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ime_pay.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ime_pay'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to integrate IME Pay in your Android and iOS app.'
  s.description      = <<-DESC
Flutter plugin to integrate IME Pay in your Android and iOS app.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'IMEPay'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
