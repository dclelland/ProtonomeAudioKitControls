#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "ProtonomeAudioKitControls"
  s.version                 = "1.4.0"
  s.summary                 = "ProtonomeAudioKitControls is a collection of IBDesignable-compatible controls for use with AudioKit 2."
  s.homepage                = "https://github.com/dclelland/ProtonomeAudioKitControls"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/ProtonomeAudioKitControls.git", :tag => "1.4.0" }
  s.platform                = :ios, '8.0'
  s.ios.deployment_target   = '8.0'
  s.ios.source_files        = 'Classes/**/*.swift'
  s.swift_version           = '4.2'
  s.requires_arc            = true
  
  s.dependency 'Bezzy', '~> 1.3'
  s.dependency 'Degrad', '~> 1.1'
  s.dependency 'Lerp', '~> 2.1'
  s.dependency 'SnapKit', '~> 4.2'
end
