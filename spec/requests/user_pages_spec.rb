require 'spec_helper'

describe "User pages:" do
  subject { page }

  describe "Signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Create account') }
    it { should have_selector('title', text: full_title('Create account')) }
  end

  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.login) }
    it { should have_selector('title', text: user.login) }
    it { should_not have_content('Password') }
  end

  describe "Account creation" do
    before { visit signup_path }

    describe "using invalid information" do
      it "should not create a user" do
        expect { click_button "Create account" }.not_to change(User, :count)
      end
    end

    describe "using valid information" do
      before do
        fill_in "Login", with: "example"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button "Create account" }.to change(User, :count).by(1)
      end
    end
  end
end
