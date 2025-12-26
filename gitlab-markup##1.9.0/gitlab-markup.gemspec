require File.expand_path('../lib/github-markup', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'gitlab-markup'
  s.version       = GitHub::Markup::VERSION
  s.summary       = 'Fork from github-markup GitLab uses to render non markdown content'
  s.description   = 'This gem is used by GitLab to render any non Markdown markup'
  s.authors       = ['Chris Wanstrath']
  s.email         = 'chris@ozmm.org'
  s.homepage      = 'https://gitlab.com/gitlab-org/gitlab-markup'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w[lib]

  s.metadata = {
    'bug_tracker_uri' => 'https://gitlab.com/gitlab-org/gitlab-markup/issues',
    'changelog_uri'   => 'https://gitlab.com/gitlab-org/gitlab-markup/blob/master/HISTORY.md',
    'source_code_uri' => 'https://gitlab.com/gitlab-org/gitlab-markup'
  }

  s.add_development_dependency 'activesupport', '~> 4.0'
  s.add_development_dependency 'html-pipeline', '~> 1.0'
  s.add_development_dependency 'minitest', '~> 5.4.3'
  s.add_development_dependency 'nokogiri', '~> 1.13.8'
  s.add_development_dependency 'nokogiri-diff', '~> 0.2.0'
  s.add_development_dependency 'sanitize', '~> 5.1.0'
end
