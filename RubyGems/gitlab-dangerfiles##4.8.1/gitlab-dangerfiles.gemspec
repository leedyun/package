require_relative "lib/gitlab/dangerfiles/version"

Gem::Specification.new do |spec|
  spec.name = "gitlab-dangerfiles"
  spec.version = Gitlab::Dangerfiles::VERSION
  spec.authors = ["GitLab"]
  spec.email = ["gitlab_rubygems@gitlab.com"]

  spec.summary = %q{This gem provides common Dangerfile and plugins for GitLab projects.}
  spec.description = %q{This gem provides common Dangerfile and plugins for GitLab projects.}
  spec.homepage = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles"
  spec.metadata["changelog_uri"] = "https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles/-/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "danger-gitlab", ">= 8.0.0"
  spec.add_dependency "danger", ">= 9.3.0"

  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "gitlab-styles", "~> 10.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "lefthook", "~> 1.3"
  spec.add_development_dependency "rspec-parameterized"
  spec.add_development_dependency "rspec", "~> 3.8"
  # we do not commit the bundle lockfile, so this temporary workaround needs to be
  # present until 2.21.3 or 2.22.x is released
  # See https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/issues/63
  spec.add_development_dependency "rubocop-rails", "< 2.21.2"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "yard"
end
