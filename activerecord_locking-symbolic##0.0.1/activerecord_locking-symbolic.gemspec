# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activerecord-locking-symbolic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["miio"]
  gem.email         = ["info@miio.info"]
  gem.description   = %q{This is can use lock symbolic option for activerecord }
  gem.summary       = %q{This is can use lock symbolic option for activerecord }
  gem.homepage      = "https://github.com/miio/activerecord-locking-symbolic"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'activerecord_locking-symbolic'
  gem.require_paths = ["lib"]
  gem.version       = ActiveRecord::Locking::Symbolic::VERSION
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end