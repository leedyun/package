# encoding: utf-8

module ActsAsCrafter
  class Railtie < Rails::Railtie
    initializer 'acts_as_crafter.configure_middleware' do |app|
      app.middleware.use(Rack::ActsAsCrafter)
    end
  end
end
