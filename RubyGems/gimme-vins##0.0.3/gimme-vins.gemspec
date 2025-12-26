# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gimme_vins/version'

Gem::Specification.new do |spec|
spec.name = 'gimme-vins'
  spec.version       = GimmeVins::VERSION
  spec.authors       = ["Jordan Stephens"]
  spec.email         = ["iam@jordanstephens.net"]
  spec.summary       = %q{Gimme some VINs}
  spec.description   = %q{Use a google search to quickly find some VINs}
  spec.homepage      = "https://github.com/jordanstephens/gimme_vins"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-byebug"

  spec.add_dependency "google-search", "~> 1.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end