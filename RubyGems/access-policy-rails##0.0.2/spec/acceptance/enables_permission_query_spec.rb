require 'acceptance_spec_helper'

feature 'Enables permission query', %q{
   In order to execute command depended on permissions
   as a developer
   I want to be able to query permissions
} do

  given(:a_controller){
    Class.new(ProtectControllerActionsSpec::DummyController) do

    end.new.tap {|c|
      c.current_user = a_user
    }
  }

  given(:a_user){
    double('user', create_allowed?: false, show_allowed?: true)
  }

  given(:service_object){
    Class.new() do
      include AccessPolicy

      def self.policy_class
        Struct.new(:current_user, :service_object) do
          def create?
            !!(current_user && current_user.create_allowed?)
          end

          def show?
            !!(current_user && current_user.show_allowed?)
          end
        end
      end

    end.new
  }

  scenario 'action is allowed' do
    expect(a_controller.policy_for(service_object).allow?(:show)).to be_truthy
  end

  scenario 'action is forbidden' do
    expect(a_controller.policy_for(service_object).allow?(:create)).to be_falsy
  end


end