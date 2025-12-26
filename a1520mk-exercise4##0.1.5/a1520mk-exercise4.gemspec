# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1520mk_exercise4/version'

Gem::Specification.new do |spec|
spec.name = 'a1520mk-exercise4'
  spec.version       = A1520mkExercise4::VERSION
  spec.authors       = ["Masatoshi Kanamaru"]
  spec.email         = ["a1520mk@aiit.ac.jp"]

  spec.summary       = %q{Kadai4 exercise.}
  spec.description   = %q{Kadai4 exercise in Framework Seminar.}
  spec.homepage      = "http://github.com/kinchan33/a1520mk_exercise4"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end