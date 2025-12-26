# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'staff_schedule/version'

Gem::Specification.new do |gem|
gem.name = '3months-staff-schedule'
  gem.version       = StaffSchedule::VERSION
  gem.authors       = ["Josh McArthur"]
  gem.email         = ["joshua.mcarthur@gmail.com"]
  gem.description   = %q{Generate a report from the 3months staff schedule}
  gem.summary       = %q{Generate a report from the 3months staff schedule}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "google_drive"
  gem.add_dependency "highline"
  gem.add_dependency "activesupport"
  gem.add_development_dependency "rake"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end