$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubocop/gitlab-security/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-gitlab-security'
  spec.summary = 'Basic security checks for projects'
  spec.description = <<~DESCRIPTION
    Basic security checking for Ruby files.
    A plugin for the RuboCop code style enforcing & linting tool.
  DESCRIPTION
  spec.homepage = 'https://gitlab.com/gitlab-org/rubocop-gitlab-security/'
  spec.authors = ['Brian Neel']
  spec.email = [
    'brian@gitlab.com'
  ]
  spec.licenses = ['MIT']

  spec.version = RuboCop::GitlabSecurity::Version::STRING
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.3.0'

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{config,lib}/**/*',
    '*.md',
    '*.gemspec',
    'Gemfile'
  ]
  spec.extra_rdoc_files = ['MIT-LICENSE.md', 'README.md']

  spec.add_runtime_dependency 'rubocop', '>= 0.51'

  spec.add_development_dependency 'rake'
end
