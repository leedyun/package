require_relative 'lib/omniauth-dingtalk/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-dingtalk-oauth2"
  spec.version       = OmniAuth::Dingtalk::VERSION
  spec.authors       = ["JiHu(GitLab)"]
  spec.email         = ["dev@jihulab.com"]

  spec.summary       = %q{Omniauth strategy for DingTalk}
  spec.description   = %q{Wrapper the DingTalk Oauth2 API}
  spec.homepage      = "https://gitlab.com/gitlab-jh/jh-team/omniauth-dingtalk"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/gitlab-jh/jh-team/omniauth-dingtalk"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.7'

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
