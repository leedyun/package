lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abbreviated_methods/version'

Gem::Specification.new do |spec|
spec.name = 'abbreviated-methods'
  spec.version       = AbbreviatedMethods::VERSION
  spec.authors       = ['Premysl Donat']
  spec.email         = ['pdonat@seznam.cz']

  spec.summary       = %q{Call methods in your objects by their's abbreviations.}
  spec.description   = %q{Just a fun little gem for playing with Ruby standard library class Abbrev. If you include AbbreviatedMethods in your class, you can call any public method by all it's possible abbreviations.}
  spec.homepage      = 'https://github.com/Masa331/abbreviated_methods'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end