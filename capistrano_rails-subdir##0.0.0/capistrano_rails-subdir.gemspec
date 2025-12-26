# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'capistrano_rails-subdir'
  gem.version       = '0.0.0'
  gem.authors       = ["Jon Pascoe"]
  gem.email         = ["jon.pascoe@me.com"]
  gem.description   = %q{Capistrano tasks for deploying one or more Ruby on Rails apps from within subdirectories of a repository}
  gem.summary       = %q{Rails tasks for Capistrano deployment of apps from within subdirectories}
  gem.homepage      = "https://github.com/pacso/capistrano-rails-subdir"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~> 3.1'
  gem.add_dependency 'capistrano-bundler', '~> 1.1'

  gem.license       = 'MIT'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end