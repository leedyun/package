# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/spider-node/version', __FILE__)

Gem::Specification.new do |spec|
spec.name = 'spider_node'
  spec.version       = Spider::Node::VERSION
  spec.authors       = ["Alin Iacob"]
  spec.email         = ["alin@thegeek.ro"]
  spec.summary       = %q{Spider ruby interface using Node.js}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/alinbsp/spider-node"
  spec.license       = "Artistic 2.0"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency 'spider-src', '~> 0.1.7'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end