require "spec_helper"

describe "Forgot password feature" do
  let(:user) { FactoryGirl.create :user }

  before :each do
    visit "/"
    click_link "Sign in"
    click_link "Forgot your password?"
    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"
    page.should have_content "You will receive an email with instructions about how to reset your password in a few minutes."
  end
  
  describe "reset password instructions email" do
    let(:mail) { ActionMailer::Base.deliveries.last }
    let(:registered_user) { User.where(email: user.email).first }

    it "has a correct subject" do
      mail.subject.should eq("Reset password instructions")
    end

    it "has a correct recipient address" do
      mail.to.should eq([user.email])
    end

    it "has a correct from address" do
      mail.from.should eq(["info@example.com"])
    end

    it "includes a confirmation link" do
      mail.body.should include(
        "http://example.com/reset/" +
        registered_user.reset_password_token
      )
    end
  end

  describe "visiting the reset password url" do
    before :each do
      reset_password_url =
        "http://example.com/reset/" +
        User.where(email: user.email).first.reset_password_token
      visit reset_password_url
    end

    it "has a correct title" do
      page.html.should have_xpath "//title", text: "Change your password"
    end
    
    it "has a correct heading" do
      page.should have_css "h1", text: "Change your password"
    end

    it "has a password field" do
      page.should have_field "user_password"
    end
    
    it "has a password confirmation field" do
      page.should have_field "user_password_confirmation"
    end
    
    it "has a change my password button" do
      page.should have_button "Change password"
    end
  end
  
  describe "resetting the password" do
    before :each do
      reset_password_url =
        "http://example.com/reset/" +
        User.where(email: user.email).first.reset_password_token
      visit reset_password_url
    end

    context "with correct details" do
      before :each do
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "newpassword"
        click_button "Change password"
      end
      
      it "should redirect to root page" do
        page.current_path.should eq("/")
      end

      it "should display an alert" do
        page.should have_content "Your password was changed successfully. You are now signed in."
      end
    end
    
    context "with empty fields" do
      before :each do
        click_button "Change password"
      end

      it "should not redirect" do
        page.current_path.should eq("/reset")
      end

      it "should display an error message" do
        page.should have_content "can't be blank"
      end
    end
    
    context "with unmatching passwords" do
      before :each do
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "notnewpassword"
        click_button "Change password"
      end

      it "should not redirect" do
        page.current_path.should eq("/reset")
      end

      it "should display an error message" do
        page.should have_content "doesn't match confirmation"
      end
    end
    
    context "with too short password" do
      before :each do
        fill_in "user_password", with: "new45"
        fill_in "user_password_confirmation", with: "new45"
        click_button "Change password"
      end

      it "should not redirect" do
        page.current_path.should eq("/reset")
      end

      it "should display an error message" do
        page.should have_content "is too short"
      end
    end
  end
end
