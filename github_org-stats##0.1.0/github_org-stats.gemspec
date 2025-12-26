# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github/org/stats/version'

Gem::Specification.new do |spec|
spec.name = 'github_org-stats'
  spec.version       = Github::Org::Stats::VERSION
  spec.authors       = ["urokuta"]
  spec.email         = ["takuro.mizobe@gmail.com"]

#   if spec.respond_to?(:metadata)
#     spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
#   end

  spec.summary       = %q{This gem summarize num of commits in your organization on github. It will encourage and accelate your team development.}
  spec.homepage      = "https://github.com/urokuta/github-org-stats"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'octokit'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end