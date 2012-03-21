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

    describe "with valid username" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.login) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "and then logging out" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end

    describe "with valid email" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in_by_email user }

      it { should have_selector('title', text: user.login) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "and then logging out" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end

  describe "Authorization" do
    describe "not provided for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the account creation page" do
          before { visit newaccount_path }
          it { should have_selector('title', text: 'Login') }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Login') }
        end

        describe "visiting the profile page" do
          before { visit user_path(user) }
          it { should have_selector('title', text: 'Login') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Login') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "when visiting a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Username", with: user.login
          fill_in "Password", with: user.password
          click_button "Login"
        end

        describe "but after signing in" do
        it "render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end
    end

    describe "not provided for unauthorized users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, login: "nope", email: "this@isnt.it") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: full_title('')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as a non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
