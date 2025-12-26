# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_model_serializers/matchers/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["adman65"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{RSpec matchers for ActiveModel::Serializers}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
gem.name = 'active-model_serializers-matchers'
  gem.require_paths = ["lib"]
  gem.version       = ActiveModel::Serializers::Matchers::VERSION

  gem.add_dependency "active_model_serializers", "~> 0.1.0"
  gem.add_dependency "rspec", "~> 2.0"

  gem.add_development_dependency "simplecov"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end