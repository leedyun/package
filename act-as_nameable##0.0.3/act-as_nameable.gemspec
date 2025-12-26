# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'act_as_nameable/version'

Gem::Specification.new do |gem|
gem.name = 'act-as_nameable'
  gem.version       = ActAsNameable::VERSION
  gem.authors       = ['caedes']
  gem.email         = ['laurentromain@gmail.com']
  gem.description   = 'Add full name methods on a model'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/caedes/act_as_nameable'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '~> 3.2.11'
  gem.add_dependency 'activerecord', '~> 3.2.11'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end