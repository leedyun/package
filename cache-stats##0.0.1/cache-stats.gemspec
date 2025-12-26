# coding: utf-8

Gem::Specification.new do |spec|
spec.name = 'cache-stats'
  spec.version       = "0.0.1"
  spec.authors       = ["Jeff McDonald"]
  spec.email         = ["jeff@jmickeyd.com"]
  spec.description   = "View file cache residency info"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/jmickeyd/cache_stats"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.extensions    = ["ext/cache_stats/extconf.rb"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end