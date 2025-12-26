#Set your home URL, so Telegram callbacks work
#For production, just use your URL (e.g. https://myapp.com)
#You MUST NOT include a trailing slash and it MUST be https!
#INVALID URLS: e.g. http://myapp.com or https://myapp.com/
TelegramNotifications::TelegramUser.configure_production_url("YOUR PRODUCTION URL")

#For development, download ngrok from https://ngrok.com/.
#Extract it and run "./ngrok http 3000"
#Then copy the URL you get from the console window.
#Remember to use the HTTPS URL!
TelegramNotifications::TelegramUser.configure_development_url("YOUR NGROK DEVELOPMENT URL")

#Set your Telegram Bot API token here
#Don't have your token yet? Create your bot using https://telegram.me/botfather
TelegramNotifications::TelegramUser.configure_token("YOUR TOKEN")
