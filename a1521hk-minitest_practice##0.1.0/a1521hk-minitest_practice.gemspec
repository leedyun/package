# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1521hk_minitest_practice/version'

Gem::Specification.new do |spec|
spec.name = 'a1521hk-minitest_practice'
  spec.version       = A1521hkMinitestPractice::VERSION
  spec.authors       = ["Hiroshi Kamatsuka"]
  spec.email         = ["a1521hk@aiit.act.jp"]

  spec.summary       = %q{minitest}
  spec.description   = %q{minitest}
  spec.homepage      = "http://rubygems.org/gems/a1521hk_minitest_practice"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
#  else
#    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
#  end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end