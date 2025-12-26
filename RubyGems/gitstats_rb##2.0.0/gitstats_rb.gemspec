# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
s.name = 'gitstats_rb'
  s.version     = '2.0.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Mario Werner', 'Christoph Plank']
  s.email       = ['mario.werner@iaik.tugraz.at', 'chrisistuff@gmail.com']
  s.homepage    = 'https://github.com/niosHD/gitstats-rb'
  s.summary     = %q{Generates statistics of git repositories}
  s.description = %q{Generates statistics of git repositories like http://gitstats.sourceforge.net but with a more extendable and flexible backend system}
  s.has_rdoc    = false
  s.license     = 'GPL-3.0'

  s.add_dependency 'haml', '~> 5.0'
  s.add_dependency 'sass', '~> 3.4'
  s.add_dependency 'compass', '~> 1.0'
  s.add_dependency 'compass-blueprint', '~> 1.0'
  s.add_dependency 'gnuplot', '~> 2.6'

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end