module ProtectControllerActionsSpec
  class DummyController < ActionController::Base
    attr_accessor :current_user

    guarded_action :create do

    end

    guarded_action :show do

    end
  end
end