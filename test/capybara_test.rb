require "test/unit"

require "minitest/autorun"

require "capybara"

require "capybara/dsl"

require 'capybara_minitest_spec'

require_relative "../lib/kimsin.rb"

class KimsinTests < Test::Unit::TestCase

  include Capybara::DSL

  Capybara.app = Kimsin.new

#  Capybara.register_driver :rack_test do |app|

#    Capybara::RackTest::Driver.new(Kimsin, :browser => :chrome)

#  end
  

  def teardown
  
    Capybara.reset_sessions!

    Capybara.use_default_driver

  end
  
  def test_index

    visit "/"

    page.must_have_content "Login"

    page.must_have_content "Register"

  end

  def test_new_user

    visit "/user/new"

    page.must_have_content "Username"

    page.must_have_content "Password"

    page.must_have_button "Register"

  end

  def test_create_user

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "first@company.com"

      fill_in "password", :with => "abC123?*"

      fill_in "confirm_password", :with => "abC123?*"

      click_button "Register"

    end

    page.must_have_content "Logged in as first@company.com."

    page.must_have_content "Logout"

  end

  def test_same_email

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "first@company.com"

      fill_in "password", :with => "abC123?*"

      fill_in "confirm_password", :with => "abC123?*"

      click_button "Register"

    end

    page.must_have_content "We already have that email."

  end

  def test_blank_email

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => ""

      fill_in "password", :with => "abC123?*"

      fill_in "confirm_password", :with => "abC123?*"

      click_button "Register"

    end

    page.must_have_content "We need your email address."

  end

  def test_bad_email

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "bademail"

      fill_in "password", :with => "abC123?*"

      fill_in "confirm_password", :with => "abC123?*"

      click_button "Register"

    end

    page.must_have_content "Doesn't look like an email adress."

  end

  def test_blank_password

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "second@company.com"

      fill_in "password", :with => ""

      fill_in "confirm_password", :with => ""

      click_button "Register"

    end

    page.must_have_content "must not be blank"
    
  end

  def test_nodigit_password

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "second@company.com"

      fill_in "password", :with => "abCabC?*"

      fill_in "confirm_password", :with => "abCabC?*"

      click_button "Register"

    end

    page.must_have_content "has an invalid format"
    
  end

  def test_noletter_password

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "second@company.com"

      fill_in "password", :with => "123123?*"

      fill_in "confirm_password", :with => "123123?*"

      click_button "Register"

    end

    page.must_have_content "has an invalid format"
    
  end

  def test_nospecialchars_password

    visit "/user/new"

    within "form#register" do

      fill_in "email", :with => "second@company.com"

      fill_in "password", :with => "abC123a1"

      fill_in "confirm_password", :with => "abC123a1"

      click_button "Register"

    end

    page.must_have_content "has an invalid format"
    
  end

  def test_login

    visit "/login"

    within "form#login" do

      fill_in "email", :with => "first@company.com"

      fill_in "password", :with => "abC123?*"
    
      click_button "Login"

    end

    page.must_have_content "Logged in as first@company.com."

    page.must_have_content "Logout"

  end

  def test_badlogin

    visit "/login"

    within "form#login" do

      fill_in "email", :with => "third@company.com"

      fill_in "password", :with => "abC123?*"
    
      click_button "Login"

    end

    page.must_have_content "No such user or bad password."

    page.must_have_content "Username"

  end


  def test_logout

    visit "/login"

    within "form#login" do

      fill_in "email", :with => "first@company.com"

      fill_in "password", :with => "abC123?*"

      click_button "Login"

    end

    click_link "Logout"

    page.must_have_content "Login" 

    page.must_have_content "Register"
    
  end
  
end
