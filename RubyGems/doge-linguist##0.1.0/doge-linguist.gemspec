# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doge_linguist/version'

Gem::Specification.new do |spec|
spec.name = 'doge-linguist'
  spec.version       = DogeLinguist::VERSION
  spec.authors       = ["williamLin"]
  spec.email         = ["william.lin@sun-innovation.com"]

  spec.summary       = "A Linguist Explains the Grammar of Doge. Wow."
  spec.homepage      = "https://github.com/WilliamLINWEN/doge_linguist"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
    # raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7.0", ">= 3.7.0"
  spec.add_development_dependency "engtagger", "~> 0.2.1"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end