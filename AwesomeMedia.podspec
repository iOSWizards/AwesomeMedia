#
# Be sure to run `pod lib lint AwesomeMedia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AwesomeMedia'
  s.version          = '0.8.0'
  s.summary          = 'Play Sounds and Videos with AvPlayer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Play Media from any app using this library.
                       DESC

  s.homepage         = 'https://github.com/iOSWizards/AwesomeMedia'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evandro Harrison Hoffmann, Leonardo Kaminski Ferreira' => 'evandro@itsdayoff.com, leonardo@mindvalley.com' }
  s.source           = { :git => 'https://github.com/iOSWizards/AwesomeMedia.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AwesomeMedia/Classes/**/*.{swift}'
  s.ios.resources = ['AwesomeMedia/Assets/Views/*.{xib,storyboard}', 'AwesomeMedia/Assets/Gilroy/*.{otf}', 'AwesomeMedia/Assets/Assets.xcassets', 'AwesomeMedia/Assets/Localizations/*.{lproj}']
  s.ios.preserve_paths = 'AwesomeMedia/Assets/*'
  s.resource_bundles = {
    'AwesomeMedia' => ['AwesomeMedia/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png,otf,lproj}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AwesomeUIMagic'
  s.dependency 'AwesomeLoading'
end
