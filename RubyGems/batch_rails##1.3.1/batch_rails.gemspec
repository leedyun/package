# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'batch-rails/version'

Gem::Specification.new do |gem|
gem.name = 'batch_rails'
  gem.version       = Batch::Rails::VERSION
  gem.authors       = ["Ben Hainez"]
  gem.description   = %q{putting batch icons by Adam Whitcroft on the rails asset-pipline}
  gem.summary       = %q{an asset gemification of the batch icon font library}
  gem.homepage      = "https://github.com/b3nhain3s/batch-rails"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 3.1.0"
  gem.add_development_dependency "rake"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end