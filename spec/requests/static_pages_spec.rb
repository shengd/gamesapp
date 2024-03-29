require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    before { visit root_path }
    subject { page }

    it { should have_selector('h1', text: 'Gamesapp') }

    it { should have_selector('title', text: full_title()) }
  end

  describe "Help page" do
    before { visit help_path }
    subject { page }

    it { should have_selector('h1', text: 'Help') }

    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }
    subject { page }

    it { should have_selector('h1', :text => 'About the app') }

    it { page.should have_selector('title', :text => full_title('About')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    subject { page }

    it { should have_selector('h1', text: 'Contact') }

    it { should have_selector('title', text: full_title('Contact')) }
  end
end
