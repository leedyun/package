# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.authors       = ["David Ball"]
  spec.email         = ["davidnoahball@gmail.com"]
  spec.summary       = "Displays APOD information through CLI"
  spec.description   = "Uses web scraping to pull Astronomy Picture of the Day information from http://apod.nasa.gov and provides a basic CLI interface for that data"
  spec.homepage      = "http://davidnoahball.com"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = ["apod-cli"]
spec.name = 'apod_cli'
  spec.require_paths = ["lib", "lib/apod_cli"]
  spec.version       = "0.0.4"
  spec.license       = "MIT"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "colorize", "~> 0.7"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end