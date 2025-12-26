# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_search/version'

Gem::Specification.new do |spec|
spec.name = 'active-search'
  spec.version       = ActiveSearch::VERSION
  spec.authors       = ["Zachary J. Davy"]
  spec.email         = ["zachmokahn@gmail.com"]
  spec.description   = "ActiveSearch will allow any model to be 'searched for' in a text field given the 'searchable_by' attribute"
  spec.summary       = "Easily make items searchable inside of your app"
  spec.homepage      = "http://github.com/zachmokahn/active_search"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end