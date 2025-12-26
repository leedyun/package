require "spec_helper"

describe "Sign up feature" do
  let(:user) { FactoryGirl.build :user }

  before :each do
    visit "/"
    click_link "Sign up"
  end

  describe "sign up page" do
    it "has an email field" do
      page.should have_field "Email"
    end
    
    it "has a password field" do
      page.should have_field "Password"
    end
    
    it "has a password confirmation field" do
      page.should have_field "Password confirmation"
    end
    
    it "has a 'Sign up' button" do
      page.should have_button "Sign up"
    end
  end

  describe "signing up" do
    before :each do
      fill_in "Email", with: user.email
      fill_in "user_password", with: user.password
      fill_in "Password confirmation", with: user.password
    end

    context "with correct details" do
      before :each do
        click_button "Sign up"
      end

      it "redirects to root page" do
        page.current_path.should == "/"
      end

      it "displays confirmation sent message" do
        page.should have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
      end

      it "does not sign in automatically" do
        page.should have_link "Sign in"
        page.should_not have_link "Sign out"
      end
    end

    context "without email" do
      before :each do
        fill_in "Email", with: ""
        click_button "Sign up"
      end

      it "displays error message" do
        page.should have_content "can't be blank"
      end
    end
    
    context "with an existing email" do
      let(:existing_user) { FactoryGirl.create :user }

      before :each do
        fill_in "Email", with: existing_user.email
        click_button "Sign up"
      end

      it "displays error message" do
        page.should have_content "has already been taken"
      end
    end
    
    context "without password" do
      before :each do
        fill_in "user_password", with: ""
        fill_in "Password confirmation", with: ""
        click_button "Sign up"
      end

      it "displays error message" do
        page.should have_content "can't be blank"
      end
    end

    context "with invalid password confirmation" do
      before :each do
        fill_in "Password confirmation", with: "somethingelse"
        click_button "Sign up"
      end

      it "displays error message" do
        page.should have_content "doesn't match confirmation"
      end
    end

    context "with too short password" do
      before :each do
        fill_in "user_password", with: "foo45"
        fill_in "Password confirmation", with: "foo45"
        click_button "Sign up"
      end

      it "displays error message" do
        page.should have_content "is too short"
      end
    end
  end
end
