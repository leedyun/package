# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binary_search_tree/version'

Gem::Specification.new do |s|
s.name = 'binary-search_tree'
  s.version = BinarySearch::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Misha Conway"]
  s.email = "MishaAConway@gmail.com"
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.licenses = ["MIT"]
  s.rubyforge_project = "nowarning"
  s.rubygems_version = "2.4.5"
  s.summary = "A self balancing avl binary search tree class. Also includes BinarySearchTreeHash which is a hash like class that internally uses binary search tree."
  s.add_development_dependency "rspec"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end