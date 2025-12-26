module AccessPolicyRails
  class Railtie < ::Rails::Railtie
    initializer "access_policy_rails.extend_controllers" do |app|

      ActiveSupport.on_load :action_controller do
        include AccessPolicyRails::ControllerExtensions
      end

    end
  end
end