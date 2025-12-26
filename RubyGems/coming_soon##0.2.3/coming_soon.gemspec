# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coming_soon/version'

Gem::Specification.new do |spec|
  spec.name          = "coming_soon"
  spec.version       = ComingSoon::VERSION
  spec.authors       = ["Terry Blue"]
  spec.email         = ["terryblue@comcast.net"]

  spec.summary       = "Movies Coming Soon"
  spec.description   = "Provides details of movies coming soon"
  spec.homepage      = "https://rubygems.org/gems/coming_soon"
  spec.license       = 'MIT'

  spec.files          = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables    = ['coming-soon']
  spec.require_paths  = ['lib']

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", ">= 0"
  spec.add_dependency "nokogiri", ">= 0"
end
