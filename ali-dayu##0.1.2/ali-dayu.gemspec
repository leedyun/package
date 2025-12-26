# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ali_dayu/version'

Gem::Specification.new do |spec|
spec.name = 'ali-dayu'
  spec.version       = AliDayu::VERSION
  spec.authors       = ["windstill"]
  spec.email         = ["202070317@163.com"]

  spec.summary       = "ali dayu"
  spec.description   = "ali dayu sms & voice"
  spec.homepage      = "https://github.com/WindStill/ali_dayu"

  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end