# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/acceptance_tests_support/version')

Gem::Specification.new do |spec|
spec.name = 'acceptance-tests_support'
  spec.summary       = %q{Simplifies congiguration and run of acceptance tests.}
  spec.description   = %q{Description: simplifies congiguration and run of acceptance tests.}
  spec.email         = "alexander.shvets@gmail.com"
  spec.authors       = ["Alexander Shvets"]
  spec.homepage      = "http://github.com/shvets/acceptance_tests_support"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = AcceptanceTestsSupport::VERSION

  spec.add_development_dependency "gemspec_deps_gen", [">= 0"]
  spec.add_development_dependency "gemcutter", [">= 0"]
  
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end