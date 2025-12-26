# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'activemerchant_payline'
  gem.version       = "0.1.9"
  gem.authors       = ["Samuel Lebeau", "Arpsara", "CT2C"]
  gem.email         = ["samuel.lebeau@gmail.com", "contact@ct2c.fr"]
  gem.summary       = %q{ActiveMerchant implementation of the Payline Gateway.}
  gem.homepage      = "https://github.com/Goldmund/activemerchant-payline"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.require_paths = ["lib"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'activemerchant', '~> 1.73.0'
  gem.add_dependency 'savon', '2.11.1'

  gem.add_dependency('activesupport', '>= 3.2.14')
  gem.add_dependency('i18n', '>= 0.6.9')
  gem.add_dependency('builder', '>= 2.1.2', '< 4.0.0')
  gem.add_dependency('nokogiri', "~> 1.4")

  gem.add_development_dependency('rake')
  gem.add_development_dependency('test-unit', '> 3.0.0')
  gem.add_development_dependency('mocha', '~> 1')
  gem.add_development_dependency('thor')
  gem.add_development_dependency('dotenv')
  gem.add_development_dependency('vcr')
  gem.add_development_dependency('webmock')
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end