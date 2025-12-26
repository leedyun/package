# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin-mongoid-localize/version'

Gem::Specification.new do |gem|
gem.name = 'activeadmin_mongoid-localize'
  gem.version       = ActiveAdmin::Mongoid::Localize::VERSION
  gem.authors       = ["Gleb Tv"]
  gem.email         = ["glebtv@gmail.com"]
  gem.description   = %q{Easily edit mongoid localized fields in ActiveAdmin (all locales on one page)}
  gem.summary       = %q{Mongoid localized fields for active admin}
  gem.homepage      = "https://github.com/rs-pro/activeadmin-mongoid-localize"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency(%q<mongoid>, [">= 3.0.0"])
  gem.add_runtime_dependency(%q<formtastic>)
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end