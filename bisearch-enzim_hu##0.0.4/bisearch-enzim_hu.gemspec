# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bisearch_enzim_hu/version'

Gem::Specification.new do |spec|
spec.name = 'bisearch-enzim_hu'
  spec.version       = BisearchEnzimHu::VERSION
  spec.authors       = ["Iwan Buetti"]
  spec.email         = ["iwan.buetti@gmail.com"]
  spec.summary       = "Wrapper for Bisearch Primer Design"
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/iwan/bisearch_enzim_hu"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"

  spec.add_dependency "mechanize" # http://mechanize.rubyforge.org/Mechanize.html
  spec.add_dependency "nokogiri" # http://mechanize.rubyforge.org/Mechanize.html
  
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end