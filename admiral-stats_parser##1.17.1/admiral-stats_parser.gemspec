# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'admiral_stats_parser/version'

Gem::Specification.new do |spec|
spec.name = 'admiral-stats_parser'
  spec.version       = AdmiralStatsParser::VERSION
  spec.authors       = ["Masahiro Yoshizawa"]
  spec.email         = ["muziyoshiz@gmail.com"]

  spec.summary       = %q{JSON data parser for kancolle-arcade.net}
  spec.description   = %q{Parser for admiral stats JSON data exported from kancolle-arcade.net}
  spec.homepage      = "https://github.com/muziyoshiz/admiral_stats_parser"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end