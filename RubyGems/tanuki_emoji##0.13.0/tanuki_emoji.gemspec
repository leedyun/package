# frozen_string_literal: true

require_relative 'lib/tanuki_emoji/version'

Gem::Specification.new do |spec|
  spec.name          = 'tanuki_emoji'
  spec.version       = TanukiEmoji::VERSION
  spec.authors       = ['Gabriel Mazetto']
  spec.email         = ['brodock@gmail.com']

  spec.summary       = %q{Tanuki Emoji}
  spec.description   = %q{Tanuki Emoji provides Emoji character information and metadata with support for Noto Emoji resources as fallback}
  spec.homepage      = 'https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji'
  spec.licenses       = %w[MIT Apache2]
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/-/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/-/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    git_files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features|bin|pages)/}) }
    asset_files = Dir.glob('app/assets/**/*').reject { |f| f.match(%r{\.DS_Store}) }

    git_files + asset_files
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'i18n', '~> 1.14'

  spec.add_development_dependency 'gitlab-dangerfiles', '~> 2.11.0'
  spec.add_development_dependency 'gitlab-styles', '~> 12.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.0'
  spec.add_development_dependency 'rubocop', '~> 1.62'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-cobertura', '~> 1.4.2'
end
