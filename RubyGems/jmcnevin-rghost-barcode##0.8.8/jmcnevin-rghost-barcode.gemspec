# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
s.name = 'jmcnevin-rghost-barcode'
  s.version = "0.8.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shairon Toledo, Jeremy McNevin"]
  s.date = %q{2010-08-19}
  s.description = %q{RGhost Barcode is adapter from Barcode Writer. The Barcode Writer in Pure
Postscript is an award-winning open source barcode maker, as used by NASA.
}
  s.email = ["shairon.toledo@gmail.com", "jeremy@spokoino.net"]
  s.extra_rdoc_files = ["README.textile", "lib/rghost_barcode.rb", "lib/rghost_barcode/ps/barcode.ps", "lib/rghost_barcode/rghost_barcode_adapter.rb", "lib/rghost_barcode/rghost_barcode_base.rb", "lib/rghost_barcode/rghost_barcode_classes.rb", "lib/rghost_barcode/rghost_barcode_examples.rb", "lib/rghost_barcode/rghost_barcode_version.rb"]
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.homepage = %q{http://github.com/jmcnevin/rghost-barcode}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Jmcnevin-rghost_barcode", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jmcnevin-rghost_barcode}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{RGhost Barcode is adapter from Barcode Writer. The Barcode Writer in Pure Postscript is an award-winning open source barcode maker, as used by NASA.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rghost>, [">= 0"])
    else
      s.add_dependency(%q<rghost>, [">= 0"])
    end
  else
    s.add_dependency(%q<rghost>, [">= 0"])
  end
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end