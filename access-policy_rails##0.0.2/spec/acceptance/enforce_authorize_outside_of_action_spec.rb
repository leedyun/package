require 'acceptance_spec_helper'

feature 'Enforce authorize outside of a controller action', %q{
   In order to enforce authorization in service objects
   as a developer
   I want to be able to mark actions as authorization needed but not self authorized
} do

  given(:a_controller_with_guarded_actions){
    Class.new(ProtectControllerActionsSpec::DummyController) do
      attr_accessor :service_object

      def self.policy_class
        ProtectControllerActionsSpec::DummyControllerPolicy
      end

      guarded_action :update, authorize_action: false do
        service_object.call
      end

      guarded_action :post, authorize_action: false do
        service_object.post
      end

    end.new.tap {|c|
      c.current_user = a_user
      c.service_object = service_object
    }
  }

  given(:a_user){
    double('user', create_allowed?: false, show_allowed?: false)
  }

  given(:service_object){
    Class.new() do
      include AccessPolicy

      def self.policy_class
        Struct.new(:current_user, :service_object) do
          def call?
            true
          end
        end
      end

      policy_guarded_method "call" do

      end

      def post

      end

    end.new
  }

  scenario 'action is authorized in service object' do
    expect{a_controller_with_guarded_actions.update}.not_to raise_error
  end

  scenario 'action is not authorized in service object' do
    expect{a_controller_with_guarded_actions.post}.to raise_error AccessPolicy::AuthorizeNotCalledError
  end


end