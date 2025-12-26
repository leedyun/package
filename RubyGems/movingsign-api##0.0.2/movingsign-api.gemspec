# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movingsign_api/version'

Gem::Specification.new do |spec|
spec.name = 'movingsign-api'
  spec.version       = MovingsignApi::VERSION
  spec.authors       = ["Eric Webb"]
  spec.email         = ["opensource@collectivegenius.net"]
  spec.description   = "MovingSign Communication Protocol V2.1 Implementation in Ruby"
  spec.summary       = "MovingSign Communication Protocol V2.1 Implementation in Ruby"
  spec.homepage      = "https://github.com/webmonarch/movingsign_api"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
      .reject { |path| path.match /\A\.idea\//  }     # Ignore .idea/ IntelliJ project directory
      .reject { |path| path.match /\A[^\/]+\.iml/ }   # Ignore *.iml IntelliJ module file
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "yard", "0.8.7.3"
  spec.add_development_dependency "wwtd"

  spec.add_runtime_dependency 'serialport', '~> 1.3'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end