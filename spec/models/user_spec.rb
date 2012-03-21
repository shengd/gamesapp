require 'spec_helper'

describe User do
  before do
    @user = User.new(login: "test", email: "foo@bar.baz.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:login) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }

  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }

  it { should be_valid }
  it { should_not be_admin }

  describe "blank login is invalid" do
    before { @user.login = " " }
    it { should_not be_valid }
  end

  describe "short login is invalid" do
    before { @user.login = "q" * 3 }
    it { should_not be_valid }
  end

  describe "long login is invalid" do
    before { @user.login = "q" * 21 }
    it { should_not be_valid }
  end

  describe "blank email is invalid" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo. @foo.com user@ @ user2foo.com]
  valid_addresses = %w[user@foo.com user_user.user@s.s.s.s.qq user+userrrrr@doma.in]

  invalid_addresses.each do |invalid_address|
    describe "\"#{invalid_address}\" should be invalid" do
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end

  valid_addresses.each do |valid_address|
    describe "\"#{valid_address}\" should be valid" do
      before { @user.email = valid_address }
      it { should be_valid }
    end
  end

  describe "logins and email addresses should be unique" do
    before do
      dup_user = @user.dup
      dup_user.save
    end

    it { should_not be_valid }
  end

  describe "logins and email addresses should be unique: case-insensitive" do
    before do
      dup_user = @user.dup
      dup_user.login = @user.login.upcase
      dup_user.email = @user.email.upcase
      dup_user.save
    end

    it { should_not be_valid }
  end

  describe "password should be present" do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end

  describe "password should match confirmation" do
    before { @user.password_confirmation = 'noooooooooooooooooo' }
    it { should_not be_valid }
  end

  describe "password should not be nil" do
    before { @user.password = nil }
    it { should_not be_valid }
  end

  #describe "password confirmation should not be nil" do
  #  before { @user.password_confirmation = nil }
  #  it { should_not be_valid }
  #end

  describe "should authenticate" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "password should not be too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "being set as admin" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end
end
