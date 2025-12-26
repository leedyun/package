# -*- encoding: utf-8 -*-
require File.expand_path('../lib/app-deployer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ricky Dunlop"]
  gem.email         = ["ricky@rehabstudio.com"]
  gem.description   = %q{Features a modular design allowing it to be extended for various frameworks. Includes recipes for CakePHP, Lithium, MySQL, Nginx, Apache. Uses Railsless deploy}
  gem.summary       = %q{Deploy PHP apps using Capistrano}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.add_dependency 'capistrano', ">= 2.13.5"
  gem.add_dependency 'colored', ">= 1.2.0"
gem.name = 'app_deployer'
  gem.require_paths = ["lib"]
  gem.version       = App::Deployer::VERSION
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end