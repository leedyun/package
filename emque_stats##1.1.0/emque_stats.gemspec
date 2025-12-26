# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "emque/stats/version"

Gem::Specification.new do |spec|
spec.name = 'emque_stats'
  spec.version       = Emque::Stats::VERSION
  spec.authors       = ["Ryan Williams"]
  spec.email         = ["oss@teamsnap.com"]
  spec.description   = %q{Collect and send application stats and events via Emque}
  spec.summary       = %q{Collect and send application stats and events via Emque}
  spec.homepage      = "https://github.com/teamsnap/emque-stats"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.1"

  spec.require_paths = %w(lib)
  spec.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.files += Dir.glob('lib/**/*.rb')
  spec.files += Dir.glob('spec/**/*')
  spec.test_files = Dir.glob('spec/**/*')

  spec.add_dependency "emque-producing",  "~> 1.2"

  spec.add_development_dependency "bundler", ">= 1.3.0", "< 2.0"
  spec.add_development_dependency "rake",    "~> 10.4.2"
  spec.add_development_dependency "rspec",   "~> 3.2.0"
  spec.add_development_dependency "bunny",   "~> 2.5"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "coveralls"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end