# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chalk-rake/version'

Gem::Specification.new do |gem|
gem.name = 'chalk_rake'
  gem.version       = Chalk::Rake::VERSION
  gem.authors       = ['Stripe']
  gem.email         = ['oss@stripe.com']
  gem.description   = %q{Collection of helpful Rake tasks}
  gem.summary       = %q{Collection of helpful Rake tasks}
  gem.homepage      = 'https://github.com/stripe/chalk-rake'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'mocha'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end