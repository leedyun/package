

Gem::Specification.new do |gem|
gem.name = 'amazon_search'
  gem.version     = '1.4.4'
  gem.date        = '2015-09-19'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8'

  gem.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files = `git ls-files -- test/*`.split("\n")

  gem.summary     = "A simple screenscraper to search Amazon"
  gem.description = "Simple screenscraper to search Amazon and return product titles, urls, image href, etc."
  gem.authors     = ["John Mason"]
  gem.email       = 'mace2345@gmail.com'
  gem.homepage    = 'https://github.com/m8ss/amazon-search'
  gem.license       = 'MIT'

  gem.add_runtime_dependency('mechanize',    '~> 2.7')

gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]



end