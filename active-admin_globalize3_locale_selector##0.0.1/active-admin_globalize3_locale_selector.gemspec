# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_admin_globalize3_locale_selector/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rubén Norte"]
  gem.email         = ["rubennorte@gmail.com"]
  gem.description   = %q{Active Admin Globalize3 Locale Selector}
  gem.summary       = %q{This gem adds controls to change the locale used by Globalize3 in Active Admin views. It allows you to see the content in the specified locale while keeping the admin interface in your preferred locale.}
  gem.homepage      = "http://github.com/rubennorte/activeadmin-globalize3-locale-selector"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'active-admin_globalize3_locale_selector'
  gem.require_paths = ["lib"]
  gem.version       = ActiveAdminGlobalize3LocaleSelector::VERSION
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end