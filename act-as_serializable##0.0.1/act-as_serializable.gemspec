# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'act_as_serializable/version'

Gem::Specification.new do |spec|
spec.name = 'act-as_serializable'
  spec.version = ActAsSerializable::VERSION
  spec.authors = ["Pavan Agrawal"]
  spec.email = ["pavan.agrawala@gmail.com"]
  spec.summary = %q{Tool to serialize and update the array in all type of databases}
  spec.description = %q{This tool is useful for managing the array in a text column in any database (mysql, sqlite and etc). This tool also does sensible update upon object save/create}
  spec.homepage = "https://github.com/pavanagrawal/act_as_serializable"
  spec.license = "MIT"

  spec.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end