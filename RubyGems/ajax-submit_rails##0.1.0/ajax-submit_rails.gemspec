# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ajax_submit_rails/version'

Gem::Specification.new do |spec|

spec.name = 'ajax-submit_rails'
  spec.version       = AjaxSubmitRails::VERSION
  spec.authors       = ['Anand Bait']
  spec.email         = ['anand.bait@gmail.com']

  spec.summary       = 'Integration of https://github.com/malsup/form with the Rails asset pipeline.'
  spec.description   = 'Integration of https://github.com/malsup/form with the Rails asset pipeline. Supports AJAX form submission. Also submits form with file field with AJAX request.'
  spec.homepage      = 'https://github.com/AquisTech/ajax_submit_rails'
  spec.license       = 'MIT'
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end