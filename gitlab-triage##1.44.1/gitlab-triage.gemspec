# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/triage/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlab-triage'
  spec.version       = Gitlab::Triage::VERSION
  spec.authors       = ['GitLab']
  spec.email         = ['gitlab_rubygems@gitlab.com']

  spec.summary       = 'GitLab triage automation project.'
  spec.homepage      = 'https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["rubygems_mfa_required"] = 'false'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage"
  spec.metadata["changelog_uri"] = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage/-/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").grep_v(%r{^(docs?|spec|tmp)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.1'
  spec.add_dependency 'globalid', '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'graphql-client', '~> 0.16'
  # Workaround - pin graphql version
  # see: https://github.com/github/graphql-client/issues/310
  # see: https://github.com/rmosolgo/graphql-ruby/pull/4577
  # see: https://github.com/github/graphql-client/pull/314
  # We can remove this check once PR 314 is merged and released
  spec.add_dependency 'graphql', '< 2.1.0'
  # Matching version of triage-ops's httparty
  spec.add_dependency 'httparty', '~> 0.20.0'

  spec.add_development_dependency 'gitlab-dangerfiles', '~> 2.11.0'
  spec.add_development_dependency 'gitlab-styles', '~> 12.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'lefthook', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 13.2'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'webmock', '~> 3.4'
  spec.add_development_dependency 'yard'
end
