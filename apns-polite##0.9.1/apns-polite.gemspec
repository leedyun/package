# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apns_polite/version'

Gem::Specification.new do |gem|
gem.name = 'apns-polite'
  gem.version       = ApnsPolite::VERSION
  gem.authors       = ["unchi"]
  gem.email         = ["unchi.he.meil.wo.okuru@gmail.com"]
  gem.description   = %q{apns}
  gem.summary       = %q{apns}
  gem.homepage      = "https://github.com/unchi/apns_polite"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end