# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/jdbcsplice/adapter/version'

Gem::Specification.new do |spec|
spec.name = 'activerecord_jdbcsplice-adapter'
  spec.version       = Activerecord::Jdbcsplice::Adapter::VERSION
  spec.authors       = ["Kolosek"]
  spec.email         = ["office@kolosek.com"]

  spec.summary       = %q{Splice JDBC adapter for JRuby on Rails.}
  spec.description   = %q{Splice Engine JDBC adapter for JRuby on Rails.}
  spec.homepage      = "http://splicemachine.com"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord-jdbc-adapter', "~> 1.3.21"
  spec.add_dependency 'jdbc-splice', '~> 0.1.1'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end