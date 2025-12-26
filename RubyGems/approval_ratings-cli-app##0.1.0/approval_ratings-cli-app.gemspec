# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'approval_ratings/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Nadine Fischoff"]
  spec.email         = ["nfischoff@learn.co"]
  spec.description   = %q{Pres Approval Ratings}
  spec.summary       = %q{Pres Approval Ratings}
  
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = ["approval-ratings"]  
spec.name = 'approval_ratings-cli-app'
  spec.require_paths = ["lib", "lib/approval_ratings"]
  spec.version       = ApprovalRatings::VERSION
  spec.license       = "MIT"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end