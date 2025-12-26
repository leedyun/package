# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'education_stats/version'

Gem::Specification.new do |spec|
spec.name = 'education-stats'
  spec.version       = EducationStats::VERSION
  spec.authors       = ["Chris Ewald"]
  spec.email         = ["chrisewald@gmail.com"]

  spec.summary       = "Statsd stats to multiple endpoints."
  spec.description   = "Statsd stats to multiple endpoints."
  spec.homepage      = "https://github.com/mkcode/education_stats"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'statsd-ruby'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "spirit_hands"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end