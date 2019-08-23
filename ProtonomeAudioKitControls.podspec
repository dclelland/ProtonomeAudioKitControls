#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "ProtonomeAudioKitControls"
  s.version                 = "1.5.1"
  s.summary                 = "ProtonomeAudioKitControls is a collection of IBDesignable-compatible controls for use with AudioKit 2."
  s.homepage                = "https://github.com/dclelland/ProtonomeAudioKitControls"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/ProtonomeAudioKitControls.git", :tag => "1.5.1" }
  s.platform                = :ios, '11.0'
  s.ios.deployment_target   = '11.0'
  s.ios.source_files        = 'Classes/**/*.swift'
  s.swift_version           = '5.0'
  s.requires_arc            = true

  s.dependency 'AudioKit', '~> 2.3'
  s.dependency 'Bezzy', '~> 1.4'
  s.dependency 'Degrad', '~> 1.2'
  s.dependency 'Lerp', '~> 2.2'
  s.dependency 'SnapKit', '~> 5.0'
end
