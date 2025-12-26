# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'android/command/line/tools/version'

Gem::Specification.new do |spec|
spec.name = 'android_command-line-tools'
  spec.version       = Android::Command::Line::Tools::VERSION
  spec.authors       = ['Tomoki Yamashita']
  spec.email         = ['tomorrowkey@gmail.com']

  spec.summary       = %q{Useful command line tools for android developers}
  spec.description   = %q{Useful command line tools for android developers}
  spec.homepage      = 'https://github.com/tomorrowkey/android-command-line-tools'
  spec.license       = 'Apache License 2.0'
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'device_api-android', '~> 1.2'
  spec.add_dependency 'peco_selector', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end