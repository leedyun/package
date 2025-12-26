# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letsencrypt/cli/version'

Gem::Specification.new do |spec|
spec.name = 'acme_cli'
  spec.version       = Letsencrypt::Cli::VERSION
  spec.authors       = ["Stefan Wienert"]
  spec.email         = ["stwienert@gmail.com"]

  spec.summary       = %q{slim ACME (e. g. letsencrypt) client for quickly authorizing (multiple) domains and issuing certificates}
  spec.homepage      = "https://github.com/zealot28/acme-cli"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'acme-client', '>= 0.2.4'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'colorize'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'activesupport', '>= 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr', "~> 3.0"
  spec.add_development_dependency 'webmock', "~> 1.22"
  spec.add_development_dependency 'timecop', "~> 0.8"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end