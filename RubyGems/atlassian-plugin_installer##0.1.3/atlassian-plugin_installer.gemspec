# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/atlassian_plugin_installer/version', __FILE__)

Gem::Specification.new do |spec|
spec.name = 'atlassian-plugin_installer'
  spec.version       = AtlassianPluginInstaller::VERSION
  spec.authors       = ["Martin Brehovsky"]
  spec.email         = ["mbrehovsky@adaptavist.com"]

  spec.summary       = %q{Installs JIRA plugin using UPM}
  spec.description   = %q{Installs JIRA plugin using UPM}
  spec.homepage      = "http://www.adaptavist.com"
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "bin"
  spec.executables   = ["atlassian_plugin_installer"]
  spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 1.6"
    spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end