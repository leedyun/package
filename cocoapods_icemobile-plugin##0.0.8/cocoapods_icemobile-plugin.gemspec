# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-icemobile-plugin/version.rb'

Gem::Specification.new do |spec|
spec.name = 'cocoapods_icemobile-plugin'
  spec.version       = CocoapodsIcemobilePlugin::VERSION
  spec.authors       = ["Sumeru Chatterjee"]
  spec.summary       = %q{CocoaPods plugin for internal icemobile projects.}
  spec.homepage      = "http://www.icemobile.com"
  spec.email         = "sumeru@icemobile.com"
  spec.description   = "IceMobile Plugin for CocoaPods (Used within IceMobile for internal projects."

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'cocoapods','~> 0.29'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end