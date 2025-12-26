Gem::Specification.new do |spec|
spec.name = 'lita_telegram-plus'
  spec.version       = "0.1.2"
  spec.authors       = ["Job van der Voort"]
  spec.email         = ["jobvandervoort@gmail.com"]
  spec.description   = "A better Telegram adapter for Lita"
  spec.summary       = "A better Telegram adapter for Lita"
  spec.homepage      = "http://www.jobvandervoort.com/telegram-plus"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "telegram-bot-ruby"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end