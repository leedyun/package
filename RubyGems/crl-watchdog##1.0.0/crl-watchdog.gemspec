# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crl_watchdog', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carsten Zimmermann"]
  gem.email         = ["carp@hacksocke.de"]
  gem.description   = %q{Checks if an OpenSSl certificate revocation file expires within a given amount of days}
  gem.summary       = %q{Checks if a CRL expires within a given amount of days}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'crl-watchdog'
  gem.require_paths = ["lib"]
  gem.version       = CrlWatchdog::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'activesupport'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end