# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logs_viewer/version'

Gem::Specification.new do |spec|
spec.name = 'logs-viewer'
  spec.version       = LogsViewer::VERSION
  spec.licenses      = ['MIT']
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Washington Silva"]
  spec.email         = ["w-osilva@hotmail.com"]
  spec.homepage      = ""
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.summary       = %q{ Gem to view the application logs in the browser }
  spec.description   = %q{ This gem was developed to make possible the visualization of the application logs in the browser.}

  spec.add_dependency "bundler"
  spec.add_dependency "rack", "~> 1.5"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end