# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ebay/ysr/version'

Gem::Specification.new do |spec|
spec.name = 'ebay_ysr'
  spec.version       = Ebay::Ysr::VERSION
  spec.authors       = ["Syed Muhammad Yasir"]
  spec.email         = ["yasirabbaszaidi5@gmail.com"]
  spec.summary       = %q{Finding Api of Ebay}
  spec.description   = %q{create config/initializers/ebay.rb
                       SET ebay app id :  Ebay::APPID = ''  }

  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end