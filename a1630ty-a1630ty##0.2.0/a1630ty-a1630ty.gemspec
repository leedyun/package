# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1630ty_a1630ty/version'

Gem::Specification.new do |spec|
spec.name = 'a1630ty-a1630ty'
  spec.version       = A1630tyA1630ty::VERSION
  spec.authors       = ["Write your name"]
  spec.email         = ["Write your email address"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end