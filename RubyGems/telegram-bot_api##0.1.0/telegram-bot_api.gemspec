# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram_bot_api/version'

Gem::Specification.new do |spec|
spec.name = 'telegram-bot_api'
  spec.version       = TelegramBotApi::VERSION
  spec.authors       = ["Bernat Rafales"]
  spec.email         = ["brafales@gmail.com"]

  spec.summary       = %q{Ruby client for the Telegram Bot API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/brafales/telegram_bot_api"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"

  spec.add_dependency "typhoeus", "~> 0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end