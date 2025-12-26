module ActiveApplication
  class Engine < ::Rails::Engine
    Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder
    Formtastic::Helpers::FormHelper.default_form_class = "form-horizontal"

    if Rails.env.development?
      config.action_mailer.default_url_options = { host: "localhost:3000" }
    elsif Rails.env.test?
      config.action_mailer.default_url_options = { host: "example.com" }
    elsif Rails.env.production?
      config.action_mailer.default_url_options = { host: "example.com" }
    end

    config.after_initialize do |app|
      app.routes.append { match "*path", to: "active_application/public#not_found" }
    end

    config.app_generators do |g|
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.helper false
      g.integration_tool :rspec
      g.javascripts false
      g.stylesheets false
      g.test_framework :rspec,
        view_specs: false,
        controller_specs: false,
        routing_specs: false,
        request_specs: false
    end
  end
end
