# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_lightning/version'

Gem::Specification.new do |spec|
spec.name = 'ar-lightning'
  spec.version       = ArLightning::VERSION
  spec.authors       = ["Luke"]
  spec.email         = ["email@luke-roberts.info"]
  spec.description   = %q{This gem implements some of the ideas discussed in this post:http://brainspec.com/blog/2012/09/28/lightning-json-in-rails/ for LIGHTNING fast rails APIs}
  spec.summary       = %q{Lightning fast APIs as discussed in this post:http://brainspec.com/blog/2012/09/28/lightning-json-in-rails/}
  spec.homepage      = "https://github.com/lukeroberts1990/ar_lightning"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "active_record"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end