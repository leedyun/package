require 'rails/generators'

module Slider
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "This generator load tinymce into the application.css and application.js"

      def load_tinymce
        inject_into_file "app/assets/javascripts/application.js", "//= require jquery.anythingslider\n", before:  "//= require_tree"
        inject_into_file "app/assets/stylesheets/application.css", "\n*= require anythingslider.sass", after:  "*= require_tree ."
      end
    end
  end
end
