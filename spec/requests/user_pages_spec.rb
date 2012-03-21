require 'spec_helper'

describe "User pages:" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "Signup page" do
    before { visit newaccount_path }

    it { should have_selector('h1', text: 'Create account') }
    it { should have_selector('title', text: full_title('Create account')) }
  end

  describe "Profile page" do
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.login) }
    it { should have_selector('title', text: user.login) }
    it { should_not have_content('Password') }
  end

  describe "Account creation" do
    before { visit newaccount_path }

    describe "using invalid information" do
      it "should not create a user" do
        expect { click_button "Create account" }.not_to change(User, :count)
      end
    end

    describe "using valid information" do
      before do
        fill_in "Username", with: "akjsdsjdakjsdjsa"
        fill_in "Email", with: "user@apopsgjnpa.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm password", with: "foobar"
      end

      it "as a non-admin should not create a user" do
        expect { click_button "Create account" }.to change(User, :count).by(0)
      end
    end
  end

  describe "Index" do
    before do
      FactoryGirl.create(:user, login: "Quux", email: "a@b.cd")
      FactoryGirl.create(:user, login: "xyzzy", email: "w@x.yz")
      visit users_path
    end

    it { should have_selector('title', text: 'Users') }

    it "should list all three users" do
      User.all.each do |user|
        page.should have_selector('li', text: user.login)
      end
    end

    describe "pagination" do
      before(:all) do
        @arr = []
        30.times { @arr << FactoryGirl.create(:user).id }
      end
      after(:all) { User.delete @arr }

      it { should have_link('Next') }
      it { should have_link('2') }

      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.login)
        end
      end

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "Edit" do
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Username", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Logout', :href => logout_path) }
      specify { user.reload.login.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
