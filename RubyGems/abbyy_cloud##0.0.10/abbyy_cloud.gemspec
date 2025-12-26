lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'abbyy_cloud'
  gem.version  = "0.0.10"
  gem.authors  = ["Andrew Kozin"]
  gem.email    = ["andrew.kozin@gmail.com"]
  gem.summary  = "HTTP client to ABBYY Cloud API"
  gem.homepage = "https://github.com/nepalez/abbyy-cloud"
  gem.license  = "MIT"

  gem.files            =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]
  gem.require_paths    = %w(lib)

  gem.required_ruby_version = ">= 2.3.0"

  gem.add_runtime_dependency "dry-initializer", "~> 0.9.2"
  gem.add_runtime_dependency "dry-types", "~> 0.9.0"
  gem.add_runtime_dependency "hashie", "~> 3.4"
  gem.add_runtime_dependency "multipart_body", "~> 0.2"
  gem.add_runtime_dependency "mime-types", "~> 3.1"

  gem.add_development_dependency "bundler", "~> 1.12"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rspec-its", "~> 1.2"
  gem.add_development_dependency "rubocop", "~> 0.42"
  gem.add_development_dependency "webmock", "~> 2.0"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end