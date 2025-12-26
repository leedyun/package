# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/qa/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlab-qa'
  spec.version       = Gitlab::QA::VERSION
  spec.authors       = ['GitLab Quality']
  spec.email         = ['gitlab-qa@gmail.com']

  spec.required_ruby_version = ">= 3.0.0"

  spec.summary       = 'Integration tests for GitLab'
  spec.homepage      = 'http://about.gitlab.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'climate_control', '~> 1.0.1'
  spec.add_development_dependency 'gitlab-dangerfiles', '~> 2.11'
  spec.add_development_dependency 'gitlab-styles', '~> 10'
  spec.add_development_dependency 'lefthook', '~> 1.2.6'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'pry-byebug', '~> 3.10.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-cobertura', '~> 2.1'
  spec.add_development_dependency 'solargraph', '~> 0.41'
  spec.add_development_dependency 'timecop', '~> 0.9.5'
  spec.add_development_dependency 'webmock', '3.7.0'

  spec.add_runtime_dependency 'activesupport', '>= 6.1', '< 7.2'
  spec.add_runtime_dependency 'ffi', '~> 1.17'
  spec.add_runtime_dependency 'gitlab', '~> 4.19'
  spec.add_runtime_dependency 'http', '~> 5.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'
  spec.add_runtime_dependency 'parallel', '>= 1', '< 2'
  spec.add_runtime_dependency 'rainbow', '>= 3', '< 4'
  spec.add_runtime_dependency 'table_print', '1.5.7'
  spec.add_runtime_dependency 'zeitwerk', '>= 2', '< 3'
end
