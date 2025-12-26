module HideAssetLogs
  class Railtie < Rails::Railtie
    initializer "hide_asset_logs" do
      unless Rails.env.production?
        Rails.application.middleware.insert_before Rails::Rack::Logger, HideAssetLogs::Middleware
      end
    end
  end
end
