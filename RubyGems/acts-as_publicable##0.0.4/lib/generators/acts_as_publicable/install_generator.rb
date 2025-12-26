module ActsAsPublicable
    module Generators

        class InstallGenerator < Rails::Generators::Base
            source_root File.expand_path('../templates', __FILE__)
            argument :name, :type => :string, :default => "publicables"

            desc "install the common controller and the common helper in your app"

            def copy_controller
                template "controller.rb", "app/controllers/#{name.underscore}_controller.rb"
            end

            def copy_helper
                template "helper.rb", "app/helpers/#{name.underscore}_helper.rb"
            end            

            def add_route
                route "put '/#{name.underscore.pluralize}/:id/:type' => '#{name.underscore.pluralize}#publish', :as => :publishable"
                route "acts_as_publicable :#{name.underscore.singularize}"
            end

        end

    end
end
