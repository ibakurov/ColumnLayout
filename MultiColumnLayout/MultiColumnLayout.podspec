
Pod::Spec.new do |s|
s.name             = 'MultiColumnLayout'
s.version          = '0.1.0'
s.summary          = 'The layout for collection view to support multicolumn view.'

s.description      = <<-DESC
This layout can be used on iPhone and iPad. It can also change the number of columns after the rotation to have more dynaic views.
DESC

s.homepage         = 'https://github.com/ibakurov/MultiColumnLayout'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Illya Bakurov' => 'bakurov.illya@gmail.com' }
s.source           = { :git => 'https://github.com/ibakurov/MultiColumnLayout.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'MultiColumnLayout/MultiColumnLayout.swift'

end
