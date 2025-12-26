class BaseControllerDummy
  def self.hide_action(method)
    @hidden_actions ||= []
    @hidden_actions << method
  end

  def self.helper_method(*)

  end

  def self.hidden_actions
    @hidden_actions
  end

  def self.policy_class
    @policy_class ||= Struct.new(:current_user, :controller) do
      def create?
        current_user && current_user.create_allowed?
      end

      def show?
        current_user && current_user.show_allowed?
      end
    end
  end
end