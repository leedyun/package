# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cnvrg/version'

Gem::Specification.new do |spec|
    spec.name          = 'cnvrg'
    spec.version       = Cnvrg::VERSION
    spec.authors       = ['Yochay Ettun', 'Leah Kolben', 'Omer Shacham']
    spec.email         = ['info@cnvrg.io']
    spec.summary       = %q{A CLI tool for interacting with cnvrg.io.}
    spec.description   = %q{A CLI tool for interacting with cnvrg.io.}
    spec.homepage      = 'https://cnvrg.io'

    #spec.files         = `git ls-files`.split($/)
    spec.files = %w[cnvrg.gemspec] + Dir['*.md', 'bin/*', 'lib/**/*.rb']
    spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.executables = ['cnvrg']
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler'
    spec.add_development_dependency 'rake', '~> 10.0'
    spec.add_development_dependency 'rspec', '~> 3.0'
    spec.add_development_dependency 'vcr', '~> 3.0'
    spec.add_development_dependency 'aruba'
    spec.add_development_dependency 'pry'

    spec.add_runtime_dependency 'ffi', '~> 1.9', '>= 1.9.10'
    spec.add_runtime_dependency 'mimemagic', '~> 0.3.1', '>=0.3.7'
    spec.add_runtime_dependency 'faraday', '~> 0.15.2'
    spec.add_runtime_dependency 'warning', '~> 1.3.0'
    spec.add_runtime_dependency 'netrc', '~> 0.11.0'
    spec.add_runtime_dependency 'open4', '~> 1.3', '>= 1.3.4'
    spec.add_runtime_dependency 'highline', '~> 1.7', '>= 1.7.8'
    spec.add_runtime_dependency 'thor', '~> 0.19.0', '>=0.19.1'
    spec.add_runtime_dependency 'aws-sdk-s3', '~> 1'
    spec.add_runtime_dependency 'signet', '~> 0.11.0'
    spec.add_runtime_dependency 'google-cloud-env', '~> 1.2.1'
    spec.add_runtime_dependency 'google-cloud-core', '~> 1.3.2'
    spec.add_runtime_dependency 'google-cloud-storage', '~> 1.21.1'
    spec.add_runtime_dependency 'sucker_punch', '~> 2.0'
    spec.add_runtime_dependency 'urlcrypt', '~> 0.1.1'
    spec.add_runtime_dependency 'filewatch', '~> 0.9.0'
    spec.add_runtime_dependency 'parallel', '~> 1.12.0'
    spec.add_runtime_dependency 'azure-storage-blob', '~> 1.1.0'
    spec.add_runtime_dependency 'logstash-logger', '~> 0.22.1'
    spec.add_runtime_dependency 'activesupport', '~> 5.2.0'
    spec.add_runtime_dependency 'ruby-progressbar'
    spec.add_runtime_dependency 'down'
end
