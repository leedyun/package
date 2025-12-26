# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apitool/client/version'

Gem::Specification.new do |s|
s.name = 'apitool_client'
  s.version       = Apitool::Client::VERSION
  s.authors       = ["Terranova David"]
  s.email         = ["dterranova@adhara-cybersecurity.com"]
  s.summary       = %q{APITool client.}
  s.description   = %q{APITool client.}
  s.homepage      = ""
  s.license       = "MIT"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "debugger2"

  s.add_dependency 'rest-client'
  s.add_dependency 'rails'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end