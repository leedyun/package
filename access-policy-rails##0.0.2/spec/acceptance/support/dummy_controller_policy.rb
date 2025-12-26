module ProtectControllerActionsSpec
  DummyControllerPolicy = Struct.new(:current_user, :controller) do
    def create?
      current_user && current_user.create_allowed?
    end

    def show?
      current_user && current_user.show_allowed?
    end
  end
end