#
# Be sure to run `pod lib lint MRTableViewCellCountScrollIndicator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MRTableViewCellCountScrollIndicator'
  s.version          = '0.0.4'
  s.summary          = 'Table View Cell Scroll Count Indicator'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Shows a simple scroll count indicator when the user scrolls up and down in the tableView.
                       DESC

  s.homepage         = 'https://github.com/xTrinch/MRTableViewCellCountScrollIndicator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mojca Rojko' => 'mojca.rojko@gmail.com' }
  s.source           = { :git => 'https://github.com/xTrinch/MRTableViewCellCountScrollIndicator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MRTableViewCellCountScrollIndicator/Classes/**/*'
  s.resource_bundles = {
      'MRTableViewCellCountScrollIndicator' => ['MRTableViewCellCountScrollIndicator/Assets/*.{png,xib}']
  }
  # s.resource_bundles = {
  #   'MRTableViewCellCountScrollIndicator' => ['MRTableViewCellCountScrollIndicator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
