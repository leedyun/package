require 'acceptance_spec_helper'

feature 'Protect controller actions', %q{
   In order to secure my rails application
   as a developer
   I want to protect some actions
} do

  given(:a_controller_with_guarded_actions){
    ProtectControllerActionsSpec::DummyController.new.tap {|c| c.current_user = a_user}
  }

  given(:a_user){
    double('user', create_allowed?: false, show_allowed?: true)
  }

  scenario "access protected actions without permission" do
    expect{a_controller_with_guarded_actions.create}.to raise_error AccessPolicy::NotAuthorizedError
  end

  scenario "access protected actions with permission" do
    expect{a_controller_with_guarded_actions.show}.not_to raise_error
  end

end