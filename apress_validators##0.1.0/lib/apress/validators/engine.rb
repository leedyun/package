module Apress
  module Validators
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib"]
      config.i18n.load_path += Dir[config.root.join('locales', '*.{rb,yml}').to_s]
    end
  end
end
