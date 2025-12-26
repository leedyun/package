# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alias_scope/version'

Gem::Specification.new do |spec|
spec.name = 'alias-scope'
  spec.version       = AliasScope::VERSION
  spec.authors       = ["Michael Righi"]
  spec.email         = ["michael@righi.me"]
  spec.summary       = %q{Creates aliases of ActiveRecord named scopes.}
  spec.description   = %q{Creates aliases of ActiveRecord named scopes.}
  spec.homepage      = "https://github.com/righi/alias_scope"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "minitest", "~> 4.7.5"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end