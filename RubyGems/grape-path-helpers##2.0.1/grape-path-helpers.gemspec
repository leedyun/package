require File.join(Dir.pwd, 'lib', 'grape-path-helpers', 'version')

Gem::Specification.new do |gem|
  gem.name        = 'grape-path-helpers'
  gem.version     = GrapePathHelpers::VERSION
  gem.licenses    = ['MIT']
  gem.summary     = 'Route path helpers for Grape'
  gem.description = 'Route path helpers for Grape'
  gem.authors     = ['Drew Blessing', 'Harper Henn']
  gem.email       = ''
  gem.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.homepage    = 'https://gitlab.com/gitlab-org/grape-path-helpers'

  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'grape', '~> 2.0'
  gem.add_runtime_dependency 'rake', '> 12'
  gem.add_runtime_dependency 'ruby2_keywords', '~> 0.0.2'

  gem.add_development_dependency 'pry', '~> 0.11'
  gem.add_development_dependency 'rspec', '~> 3.7'
  gem.add_development_dependency 'rubocop', '~> 0.56'
end
