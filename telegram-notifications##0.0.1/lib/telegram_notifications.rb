require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))

module TelegramNotifications
  if defined?(ActiveRecord::Base)
    require 'telegram_notifications/telegram_user'
    require 'telegram_notifications/telegram_controller'
  end
end

