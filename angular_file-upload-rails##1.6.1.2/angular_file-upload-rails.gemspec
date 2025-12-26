# -*- encoding: utf-8 -*-
require File.expand_path('../lib/angular-file-upload/version', __FILE__)

Gem::Specification.new do |gem|
gem.name = 'angular_file-upload-rails'
  gem.version       = AngularFileUpload::VERSION
  gem.date          = '2014-07-23'
  gem.authors       = ['Joe DiVita']
  gem.email         = ['joediv31@gmail.com']
  gem.description   = %q{ Includes an AngularJS Directive for uploading files as an asset in the Rails Asset Pipeline }
  gem.summary       = %q{ Includes an AngularJS Directive for uploading files as an asset in the Rails Asset Pipeline }
  gem.homepage      = 'https://github.com/joedivita/angular-file-upload-rails'
  gem.license       = 'MIT'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency 'railties', '>= 3.1'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rails', '>= 3.1'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end