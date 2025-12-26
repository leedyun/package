class SubscribeController < ApplicationController
  def webhook
    if params[:message]
      user = TelegramUser.create( { telegram_id: params[:message][:from][:id], first_name: params[:message][:from][:first_name],last_name: params[:message][:from][:last_name] } )
      if user
        user.send_message("Notifications are now active. To cancel, stop this bot in Telegram.")
      end
      render :nothing => true, :status => :ok
    end
  end
end