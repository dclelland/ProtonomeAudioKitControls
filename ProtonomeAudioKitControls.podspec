#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "ProtonomeAudioKitControls"
  s.version                 = "0.1.0"
  s.summary                 = "ProtonomeAudioKitControls is a collection of IBDesignable-compatible controls for use with AudioKit 2."
  s.homepage                = "https://github.com/dclelland/ProtonomeAudioKitControls"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/Bezzy.git", :tag => "0.1.0" }
  s.platform                = :ios, '8.0'
  s.ios.deployment_target   = '8.0'
  s.ios.source_files        = 'Classes/**/*.swift'
  s.requires_arc            = true
  
  s.dependency 'AudioKit', '~> 2.0'
  s.dependency 'Bezzy'
  s.dependency 'Degrad'
  s.dependency 'Lerp'
  s.dependency 'SnapKit'
end
