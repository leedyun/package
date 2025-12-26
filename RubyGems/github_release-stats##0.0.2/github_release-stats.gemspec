# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github/release/stats/version'

Gem::Specification.new do |spec|
spec.name = 'github_release-stats'
  spec.version       = Github::Release::Stats::VERSION
  spec.authors       = ["Wei Lu"]
  spec.email         = ["luwei.here@gmail.com"]
  spec.description   = %q{Return release download stats for a given github project owner/project}
  spec.summary       = %q{Return release download stats for a given github project owner/project}
  spec.homepage      = "https://github.com/weilu/github-release-stats"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "thor"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end