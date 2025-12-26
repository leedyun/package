# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_publicable/version"

Gem::Specification.new do |s|
s.name = 'acts-as_publicable'
    s.version     = ActsAsPublicable::VERSION
    s.platform    = Gem::Platform::RUBY
    s.authors     = ["lucapette"]
    s.email       = ["lucapette@gmail.com"]
    s.homepage    = "https://github.com/lucapette/acts_as_publicable"
    s.summary     = %q{a simple ActiveRecord extension for handling publishable stuff}
    s.description = %q{This gem will give you only two scopes and a method for handling
published/unpublished stuff. Nothing remarkable bur saved me a lot of typing
when I wrote it for a project with an huge number of publishable models.
Suggestions are more than welcome.}

    s.add_development_dependency 'sqlite3'
    s.add_dependency "rails", ">= 3.0.0"
    s.add_development_dependency "rspec-rails", ">= 2.5.0"

    s.rubyforge_project = "acts_as_publicable"

    s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
    s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end