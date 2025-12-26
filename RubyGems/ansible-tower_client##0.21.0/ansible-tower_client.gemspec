# coding: utf-8
require_relative 'lib/ansible_tower_client/version'

Gem::Specification.new do |spec|
spec.name = 'ansible-tower_client'
  spec.version       = AnsibleTowerClient::VERSION
  spec.authors       = ["Brandon Dunne", "Drew Bomhof"]
  spec.email         = ["bdunne@redhat.com", "dbomhof@redhat.com"]

  spec.summary       = %q{Ansible Tower REST API wrapper gem}
  spec.description   = %q{Ansible Tower REST API wrapper gem}
  spec.homepage      = "https://github.com/Ansible/ansible_tower_client_ruby"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "more_core_extensions", "~> 3.0"

  spec.add_development_dependency "factory_bot", "~> 4.11"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end