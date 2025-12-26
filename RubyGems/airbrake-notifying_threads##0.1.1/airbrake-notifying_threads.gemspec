# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'airbrake_notifying_threads/version'

Gem::Specification.new do |spec|
spec.name = 'airbrake-notifying_threads'
  spec.version       = AirbrakeNotifyingThreads::VERSION
  spec.authors       = ["alekseyl"]
  spec.email         = ["leshchuk@gmail.com"]

  spec.summary       = %q{Thread actions with Airbrake notofication.}
  spec.description   = %q{Thread actions with Airbrake notofication.}
  spec.homepage      = "https://github.com/alekseyl/airbrake_notifying_threads"
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

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'airbrake', '>=4'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end