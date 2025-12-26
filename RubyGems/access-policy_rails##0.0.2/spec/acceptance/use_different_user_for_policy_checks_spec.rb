require 'acceptance_spec_helper'

feature 'Use different user for policy checks', %q{
   In order to use another user then the current user
   as a developer
   I want to be able to override policy_check_user
} do

  given(:a_controller_with_guarded_actions){
    Class.new(ProtectControllerActionsSpec::DummyController) do
      attr_accessor :other_user

      def self.policy_class
        ProtectControllerActionsSpec::DummyControllerPolicy
      end

      protected
      def policy_check_user
        other_user
      end
    end.new.tap {|c|
      c.current_user = a_user
      c.other_user = a_user_with_permissions
    }
  }

  given(:a_user){
    double('user', create_allowed?: false, show_allowed?: false)
  }

  given(:a_user_with_permissions){
    double('a_user_with_permissions', create_allowed?: true, show_allowed?: true)
  }

  scenario 'policy check user is overridden' do
    expect{a_controller_with_guarded_actions.create}.not_to raise_error
  end


end