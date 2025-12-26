require "font_awesome/sass/rails/helpers"

module FontAwesome
  module Sass
    module Rails
      class Railtie < ::Rails::Railtie
       initializer "font-awesome-sassc.view_helpers" do
          ActionView::Base.send :include, ViewHelpers
        end
      end
    end
  end
end
