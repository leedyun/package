# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doge_woof/version'

Gem::Specification.new do |spec|
spec.name = 'doge-woof'
  spec.version       = DogeWoof::VERSION
  spec.authors       = ["Ruppal Singh"]
  spec.email         = ["ruppalsingh.dv@gmail.com"]

  spec.summary       = "Woofs a doge response in the specified word/line/paragraph length."
  spec.description   = "Wow ipsum. Such lorem. Leave ipsum lorem behind! Amaze your fellow devs."
  spec.homepage      = "http://github.com/ruppalsingh/my_doge"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "doge_woof", "~> 0.1.10"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end