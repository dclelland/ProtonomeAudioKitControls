#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "ProtonomeAudioKitControls"
  s.version                 = "1.0.0"
  s.summary                 = "ProtonomeAudioKitControls is a collection of IBDesignable-compatible controls for use with AudioKit 3."
  s.homepage                = "https://github.com/dclelland/ProtonomeAudioKitControls"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/ProtonomeAudioKitControls.git", :tag => "1.0.0" }
  s.platform                = :ios, '9.0'
  s.ios.deployment_target   = '9.0'
  s.ios.source_files        = 'Classes/**/*.swift'
  s.requires_arc            = true
  
  s.dependency 'AudioKit', '~> 3.4'
  s.dependency 'Bezzy', '~> 1.0'
  s.dependency 'Degrad', '~> 1.0'
  s.dependency 'Lerp', '~> 2.0'
  s.dependency 'SnapKit', '~> 3.0'
end
