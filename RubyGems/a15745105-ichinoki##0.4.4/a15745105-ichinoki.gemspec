# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a15745105_ichinoki/version'

Gem::Specification.new do |spec|
spec.name = 'a15745105-ichinoki'
  spec.version       = A15745105Ichinoki::VERSION
  spec.authors       = ["Shigeru Ichinoki"]
  spec.email         = ["a1505si@aiit.ac.jp"]

  spec.summary       = %q{bmi is calculated.}
  spec.description   = %q{bmi_cal_ichinoki(kg, cm) ex)bmi_cal_ichinoki(85.0, 175.5)}
  spec.homepage      = "https://github.com/ShigeruIchinoki/a15745105_ichinoki"

  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end