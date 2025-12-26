require 'acceptance_spec_helper'

feature 'Expose helper', %q{
   In order to change views dependent on permissions
   as a developer
   I want to be able to query permissions in views
}, type: :helper do

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

  given(:a_user){
    double('user', create_allowed?: false, show_allowed?: true)
  }

  scenario 'action is allowed' do
    allow(controller).to receive(:current_user).and_return a_user
    expect(helper.policy_for(service_object).allow?(:show)).to be_truthy
  end

  scenario 'action is forbidden' do
    allow(controller).to receive(:current_user).and_return a_user
    expect(helper.policy_for(service_object).allow?(:create)).to be_falsy
  end

end