# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ackintosh/net/empty_port/version'

Gem::Specification.new do |spec|
spec.name = 'ackintosh-net-empty-port'
  spec.version       = Ackintosh::Net::EmptyPort::VERSION
  spec.authors       = ["Akihito Nakano"]
  spec.email         = ["sora.akatsuki@gmail.com"]
  spec.description   = %q{Find a free TCP/UDP port}
  spec.summary       = %q{Find a free TCP/UDP port}
  spec.homepage      = "http://ackintosh.github.io/"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end