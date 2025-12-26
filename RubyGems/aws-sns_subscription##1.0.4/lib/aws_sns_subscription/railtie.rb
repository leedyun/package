module AWSSNSSubscription
  class Railtie < Rails::Railtie
    initializer "aws_sns_subscription.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include AWSSNSSubscription::Confirmer
      end
    end
  end
end