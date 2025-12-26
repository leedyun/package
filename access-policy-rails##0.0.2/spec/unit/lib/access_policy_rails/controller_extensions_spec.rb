require 'unit_spec_helper'

module AccessPolicyRails
  describe ControllerExtensions do

    subject{
      Class.new(BaseControllerDummy) do
        include ControllerExtensions

        attr_accessor :current_user

        def initialize(current_user=nil)
          self.current_user = current_user
        end

        guarded_action :create do

        end

        guarded_action :show do

        end

      end
    }

    let(:user){
      double('user', create_allowed?: false, show_allowed?: true)
    }


    describe '.include' do
      it 'sets the storage to request local' do
        expect(subject.new._scope_storage).to be AccessPolicyRails::RequestLocalStorage
      end
    end

    describe '.guarded_action' do
      it 'creates a guarded method' do
        expect(subject.new).to respond_to :create
        expect(subject.hidden_actions).to include :create_with_guard
        expect(subject.hidden_actions).to include :create_with_guard_unsafe
      end

      it 'protects access to guarded methods' do
        expect{subject.new(user).create}.to raise_error AccessPolicy::NotAuthorizedError
        expect{subject.new(user).show}.not_to raise_error
      end

      it 'skips action authorization when wanted' do
        controller = Class.new(subject) do

          guarded_action :update, authorize_action: false do
            authorize(self,'show')
          end
        end.new(user)

        expect{controller.update}.not_to raise_error
      end

    end

    describe '#policy_check_user' do
      let(:user_without_rights){
        double('user', create_allowed?: false, show_allowed?: false)
      }

      it 'uses the current_user as default' do
        expect(subject.new(user).policy_check_user).to eq user
      end

      it 'is used for policy checks' do
        controller = subject.new(user)
        def controller.policy_check_user
          user_without_rights
        end

        expect{controller.show}.to raise_error
      end

    end

    describe '#policy_for' do
      it 'returns a wrapped policy' do
        expect(subject.new(user).policy_for).to be_kind_of PolicyWrapper
      end
    end

    describe '#policy' do
      it 'returns a policy' do
        expect(subject.new(user).policy).to be_kind_of subject.policy_class
      end
    end
  end
end