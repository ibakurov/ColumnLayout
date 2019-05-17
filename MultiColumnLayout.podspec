
Pod::Spec.new do |s|

s.name             = 'MultiColumnLayout'
s.version          = '0.3.0'

s.summary          = 'The layout for collection view to support multicolumn view.'
s.description      = <<-DESC
This layout can be used on iPhone and iPad. It can also change the number of columns after the rotation to have more dynamic views.
DESC

s.homepage         = 'https://github.com/ibakurov/MultiColumnLayout'

s.license          = { :type => 'MIT', :file => 'LICENSE' }

s.author           = { 'ibakurov' => 'bakurov.illya@gmail.com' }
s.social_media_url = 'http://twitter.com/ibakurov'

s.source           = { :git => 'https://github.com/ibakurov/MultiColumnLayout.git', :tag => s.version }
s.source_files     = 'MultiColumnLayout/Classes/**/*.{swift}'

s.ios.deployment_target = '10.0'
s.swift_version = '4.2'

s.framework = 'UIKit'

end
