# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require '99designs/tasks/version'

Gem::Specification.new do |spec|
spec.name = '99designs_tasks'
  spec.version       = NinetyNine::Tasks::VERSION
  spec.authors       = ["Dennis Hotson"]
  spec.email         = ["dennis@99designs.com"]
  spec.summary       = %q{99designs Tasks API client}
  spec.description   = %q{99designs Tasks API client}
  spec.homepage      = "https://github.com/99designs/tasks-api-ruby"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 0.8"
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "mime-types"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end