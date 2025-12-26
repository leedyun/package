# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "gitlab-labkit"
  spec.version = `git describe --tags`.chomp.gsub(/^v/, "")
  spec.authors = ["Andrew Newdigate"]
  spec.email = ["andrew@gitlab.com"]

  spec.summary = "Instrumentation for GitLab"
  spec.homepage = "https://gitlab.com/gitlab-org/labkit-ruby"
  spec.metadata = { "source_code_uri" => "https://gitlab.com/gitlab-org/ruby/gems/labkit-ruby" }
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|tools)/}) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"

  # Please maintain alphabetical order for dependencies
  spec.add_runtime_dependency "actionpack", ">= 5.0.0", "< 8.1.0"
  spec.add_runtime_dependency "activesupport", ">= 5.0.0", "< 8.1.0"
  spec.add_runtime_dependency "grpc", ">= 1.62" # Be sure to update the "grpc-tools" dev_dependency too
  spec.add_runtime_dependency "jaeger-client", "~> 1.1.0"
  spec.add_runtime_dependency "opentracing", "~> 0.4"
  spec.add_runtime_dependency "pg_query", ">= 5.1.0", "< 7.0"
  spec.add_runtime_dependency "redis", "> 3.0.0", "< 6.0.0"

  # Please maintain alphabetical order for dev dependencies
  spec.add_development_dependency "excon", "~> 0.78.1"
  spec.add_development_dependency "faraday", "~> 1.10.3"
  spec.add_development_dependency "gitlab-dangerfiles", "~> 2.11.0"
  spec.add_development_dependency "gitlab-styles", "~> 6.2.0"
  spec.add_development_dependency "grpc-tools", ">= 1.62"
  spec.add_development_dependency "httparty", "~> 0.17.3"
  spec.add_development_dependency "httpclient", "~> 2.8.3"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "rack", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rest-client", "~> 2.1.0"
  spec.add_development_dependency "rspec", "~> 3.12.0"
  spec.add_development_dependency "rspec-parameterized", "~> 1.0"
  spec.add_development_dependency "rufo", "0.9.0"
  spec.add_development_dependency "sidekiq", ">= 5.2", "< 7"
  spec.add_development_dependency "webrick", "~> 1.7.0"
end
