lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_playing_cards/version'

Gem::Specification.new do |spec|
spec.name = 'ruby-playing_cards'
  spec.version       = RubyPlayingCards::VERSION
  spec.authors       = ["Justin McKay"]
  spec.email         = ["justinmckay16@gmail.com"]
  spec.description   = %q{Basic playing cards}
  spec.summary       = %q{Basic playing cards for playing with cards}
  spec.homepage      = "https://github.com/jcmckay/ruby_playing_cards"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end