# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dark_sky_weather/version'

Gem::Specification.new do |spec|
spec.name = 'dark-sky_weather'
  spec.version       = DarkSkyWeather::VERSION
  spec.authors       = ["Troy Leach"]
  spec.email         = ["troyleach29@gmail.com"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{forecast.io API wrapper in Ruby.}
  spec.description   = %q{forecast.io API wrapper in Ruby.}
  spec.homepage      = "https://github.com/troyleach/dark_sky_weather"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "unirest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end