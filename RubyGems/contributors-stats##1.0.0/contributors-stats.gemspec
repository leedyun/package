# -*- encoding: utf-8 -*-

require File.expand_path("../lib/contributors_stats/version.rb", __FILE__)

Gem::Specification.new do |spec|
spec.name = 'contributors-stats'
  spec.version     = ContributorsStats::VERSION
  spec.license     = 'Apache'
  spec.author      = "Michal Papis"
  spec.email       = "mpapis@gmail.com"
  spec.homepage    = "https://github.com/mpapis/contributors_stats"
  spec.summary     = %q{Calculate statics for multiple project contributoions.}

  spec.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "pluginator"

  %w{rake simplecov coveralls yard redcarpet}.each do |name|
    spec.add_development_dependency(name)
  end
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end