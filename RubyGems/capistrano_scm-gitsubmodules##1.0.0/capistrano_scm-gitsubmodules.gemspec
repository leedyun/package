# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'capistrano_scm-gitsubmodules'
  spec.version       = '1.0.0'
  spec.authors       = ['Juan Ibiapina']
  spec.email         = ['juanibiapina@gmail.com']
  spec.description   = %q{Git submodules support for Capistrano 3.x}
  spec.summary       = %q{Git submodules support for Capistrano 3.x}
  spec.homepage      = 'https://github.com/juanibiapina/capistrano-scm-gitsubmodules'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '>= 3.0.0.pre'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end