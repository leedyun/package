require "spec_helper"

describe "Sign up confirmation feature" do
  let(:user) { FactoryGirl.build :user }

  before :each do
    visit "/"
    click_link "Sign up"
    fill_in "Email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Sign up"
  end
  
  describe "confirmation email" do
    let(:confirmation_email) { ActionMailer::Base.deliveries.last }
    let(:registered_user) { User.where(email: user.email).first }

    it "has a correct subject" do
      confirmation_email.subject.should eq("Confirmation instructions")
    end

    it "has a correct recipient address" do
      confirmation_email.to.should eq([user.email])
    end

    it "has a correct from address" do
      confirmation_email.from.should eq(["info@example.com"])
    end

    it "includes a confirmation link" do
      confirmation_email.body.should include(
        "http://example.com/confirm/" +
        registered_user.confirmation_token
      )
    end
  end

  describe "visiting the confirmation url" do
    before :each do
      confirmation_url =
        "http://example.com/confirm/" +
        User.where(email: user.email).first.confirmation_token
      visit confirmation_url
    end

    it "displays a success message" do
      page.should have_content "Your account was successfully confirmed"
    end
  end
end
