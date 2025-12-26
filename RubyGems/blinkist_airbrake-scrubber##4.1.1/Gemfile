ruby "2.3.6"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/blinkist/#{repo}.git" }

group :test do
  gem "rake"
  gem "rack"
  gem "rspec"
  gem "forgery"
  gem "simplecov"
  gem "dotenv"
  gem "rspec_junit_formatter"
end

group :development, :test do
  gem 'awesome_print'
  gem "byebug"
  gem 'memory_profiler'
  gem "ruby-prof"
end

# Specify your gem"s dependencies in blinkist-core.gemspec
gemspec
