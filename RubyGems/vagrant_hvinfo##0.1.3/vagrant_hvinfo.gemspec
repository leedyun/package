Gem::Specification.new do |spec|
spec.name = 'vagrant_hvinfo'
  spec.version       = '0.1.3'
  spec.authors       = ['Zhansong Li']
  spec.email         = ['lizhansong@hvariant.com']
  spec.summary       = 'Vagrant plugin for displaying information about Hyper-V VMs'
  spec.homepage      = 'https://github.com/hvariant/vagrant-hvinfo'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.metadata = {
    "homepage_uri" => 'https://github.com/hvariant/vagrant-hvinfo',
    "source_code_uri" => 'https://github.com/hvariant/vagrant-hvinfo',
  }

  spec.required_ruby_version = '>= 2.3.3'

  spec.requirements << 'vagrant'
  spec.requirements << 'Powershell v3 or newer'
  spec.requirements << 'Hyper-V'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end