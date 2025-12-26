# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'access_policy_rails/version'

Gem::Specification.new do |spec|
spec.name = 'access-policy-rails'
  spec.version       = AccessPolicyRails::VERSION
  spec.authors       = ["Dieter Späth"]
  spec.email         = ["shad0wrunner@gmx.de"]
  spec.summary       = %q{Object oriented authorization for ruby.}
  spec.description   = %q{Object oriented authorization for ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'access_policy'
  spec.add_runtime_dependency 'request_store'
  spec.add_runtime_dependency 'activesupport', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"


  spec.add_development_dependency "rails", '~>4.0.1'
  spec.add_development_dependency "rspec-rails", "2.99.0.beta1"

  # show nicely how many specs have to be run
  spec.add_development_dependency "fuubar"
  # extended console
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'pry-remote'

  # automatic execute tasks on file changes
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'rb-fsevent'

  # https://github.com/pry/pry-stack_explorer
  spec.add_development_dependency 'pry-stack_explorer'
  # https://github.com/nixme/pry-debugger
  spec.add_development_dependency 'pry-debugger'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end