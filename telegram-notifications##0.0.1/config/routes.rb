Rails.application.routes.draw do
  post '/kkk' => 'telegram_notifications/subscribe#webhook'
end