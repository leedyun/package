module AccessPolicyRails
  module ControllerExtensions
    extend ActiveSupport::Concern

     included do
       include AccessPolicy

       AccessPolicy.instance_methods.each do |method|
         hide_action method
       end

       hide_action :policy_check_user
       hide_action :authorize
       hide_action :policy_for
       hide_action :policy

       helper_method :policy_for
       helper_method :policy

     end

    def policy_check_user
      current_user
    end

    def authorize(*args, &block)
      _guard.authorize(*args, &block)
    end

    def policy_for(object_to_guard=self)
      PolicyWrapper.new(policy(object_to_guard))
    end

    def policy(object_to_guard=self)
      _guard.send(:switched_user_or_role, policy_check_user) do
         _guard.policy_for(object_to_guard)
      end
    end

    module ClassMethods
      def guarded_action(action_name, authorize_action: true, &block)
        if authorize_action
          authorized_action(action_name, &block)
        else
          authorized_service(action_name, &block)
        end
      end

      def authorized_action(action_name, &block)
        action_name_guarded = "#{action_name}_with_guard".to_sym
        policy_guarded_method action_name_guarded, action_name ,&block

        define_method action_name do
          with_user_or_role(policy_check_user) do
            self.send(action_name_guarded)
          end
        end

        hide_action action_name_guarded
        hide_action unsafe_action_name(action_name_guarded)
      end

      def authorized_service(action_name, &block)

        define_method action_name do
          with_user_or_role(policy_check_user) do
            instance_exec &block
          end
        end

      end

    end
  end
end