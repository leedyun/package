lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'airservice/build_tools/version'

Gem::Specification.new do |spec|
spec.name = 'airservice-build_tools'
  spec.version       = AirService::BuildTools::VERSION
  spec.authors       = ["AirService"]
  spec.email         = ["devs@airservice.com"]
  spec.description   = %q{Build tools}
  spec.summary       = %q{Build toolls}
  spec.homepage      = "http://github.com/airservice/build_tools"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'plist'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'emoji-rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'fakefs'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end