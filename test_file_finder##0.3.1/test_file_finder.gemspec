# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_file_finder/version'

Gem::Specification.new do |spec|
  spec.name                  = 'test_file_finder'
  spec.version               = TestFileFinder::VERSION
  spec.licenses              = ['MIT']
  spec.authors               = ['GitLab']
  spec.email                 = ['rubygems-committee@gitlab.com']
  spec.required_ruby_version = '>= 3.0'

  spec.summary       = %q(Guesses spec file paths given input file paths.)
  spec.description   = %q(Command-line tool for guessing which spec files are relevant to a set of input file paths.)
  spec.homepage      = 'https://gitlab.com/gitlab-org/ruby/gems/test_file_finder'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://gitlab.com/gitlab-org/ruby/gems/test_file_finder'
  spec.metadata['changelog_uri'] = 'https://gitlab.com/gitlab-org/ruby/gems/test_file_finder/-/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', ['>= 1.0', '!= 2.0.0', '< 3.0']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'gitlab-dangerfiles', '~> 4.6.0'
  spec.add_development_dependency 'gitlab-styles', '~> 11.0'
  spec.add_development_dependency 'lefthook', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
