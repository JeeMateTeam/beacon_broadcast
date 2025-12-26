#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'beacon_broadcast'
  s.version          = '0.3.3'
  s.summary          = 'A Flutter plugin for turning your device into a beacon.'
  s.description      = <<-DESC
A Flutter plugin for turning your device into a beacon. Plugin uses AltBeacon library for Android and CoreLocation for iOS.
                       DESC
  s.homepage         = 'https://github.com/JeeMateTeam/beacon_broadcast'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'JeeMate Team' => 'https://github.com/JeeMateTeam' }
  s.source           = { :path => '.' }
  s.swift_version    = '5.9'
  s.source_files = 'beacon_broadcast/Sources/beacon_broadcast/**/*.swift'
  # No public headers - Swift-generated header will be used automatically
  # The generated code will use @import beacon_broadcast instead
  s.dependency 'Flutter'

  s.ios.deployment_target = '12.0'
end

