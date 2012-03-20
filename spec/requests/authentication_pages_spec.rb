require 'spec_helper'

describe "Authentication:" do
  subject { page }

  describe "Login page" do
    before { visit login_path }

    it { should have_selector('h1', text: 'Login') }
    it { should have_selector('title', text: 'Login') }
  end

  describe "Logging in" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_selector('title', text: 'Login') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      it { should_not have_link('Logout') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Username", with: user.email
        fill_in "Password", with: user.password
        click_button "Login"
      end

      it { should have_selector('title', text: user.login) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "and then logging out" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end
end
