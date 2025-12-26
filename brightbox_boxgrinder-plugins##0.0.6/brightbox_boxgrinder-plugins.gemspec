# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
s.name = 'brightbox_boxgrinder-plugins'
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Neil Wilson"]
  s.date = "2012-09-04"
  s.description = "Brightbox Cloud support for Boxgrinder"
  s.email = "hello@brightbox.co.uk"
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.md", "lib/brightbox-boxgrinder-plugins.rb", "lib/delivery/bbcloud-delivery-plugin.rb", "lib/platform/bbcloud-platform-plugin.rb", "lib/platform/src/rc_local"]
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.homepage = "http://brightbox.com"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Brightbox-boxgrinder-plugins", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "Brightbox Cloud"
  s.rubygems_version = "1.8.15"
  s.summary = "Brightbox Cloud support for Boxgrinder"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<brightbox-cli>, [">= 0"])
    else
      s.add_dependency(%q<brightbox-cli>, [">= 0"])
    end
  else
    s.add_dependency(%q<brightbox-cli>, [">= 0"])
  end
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end