module ActiveScaffoldConfigList
  #do not use module Rails... cause Rails.logger will fail
  # not sure if it is a must though...
  #module Rails
    class Engine < ::Rails::Engine
      initializer("initialize_active_scaffold_config_list", :after => "initialize_active_scaffold") do
        ActiveSupport.on_load(:action_controller) do
          require "active_scaffold_config_list/config/core.rb"
        end

        ActiveSupport.on_load(:action_view) do
          require "active_scaffold/helpers/config_list_helpers.rb"
          include ActiveScaffold::Helpers::ConfigListHelpers
        end
      end
    end
  #end
end
