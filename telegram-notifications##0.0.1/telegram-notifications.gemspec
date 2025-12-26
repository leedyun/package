# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram_notifications/version'

Gem::Specification.new do |spec|
spec.name = 'telegram-notifications'
  spec.version       = TelegramNotifications::VERSION
  spec.authors       = ["Hasan Basheer"]
  spec.email         = ["hasanbasher1989@gmail.com"]

  spec.summary       = "Rails gem to send notifications via Telegram"
  spec.description   = "telegram_notifications enables your Rails app to send notifications/messages to your users via Telegram's Bot API."
  spec.homepage      = "https://github.com/hbasheer/telegram_notifications"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
   # raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end