lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'capistrano_auth-subscriber'
  gem.version       = '0.0.1'
  gem.authors       = ["OpenTeam"]
  gem.email         = ["developers@openteam.ru"]
  gem.description   = "Capistrano auth-subscriber tasks"
  gem.summary       = "Capistrano auth-subscriber tasks"
  gem.homepage      = "https://github.com/openteam-tusur/capistrano-auth-subscriber"
  gem.license       = "MIT"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'capistrano', '~> 3.1'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end