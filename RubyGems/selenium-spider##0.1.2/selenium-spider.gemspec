# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'selenium_spider/version'

Gem::Specification.new do |spec|
spec.name = 'selenium-spider'
  spec.version       = SeleniumSpider::VERSION
  spec.authors       = ["gosho-kazuya"]
  spec.email         = ["ketsume0211@gmail.com"]

  spec.summary       = %q{Scrape websites using Firefox headlessly handled by Selenium}
  spec.description   = %q{Scrape websites using Firefox headlessly handled by Selenium}
  spec.homepage      = "https://github.com/acro5piano/selenium_spider"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.3'

  spec.add_runtime_dependency "selenium_standalone_dsl", "~> 0.1.2"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "tilt"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "haml"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end