require "test/unit"

require "minitest/autorun"

require "rack/test"

require 'capybara'

require 'capybara/dsl'

require_relative "../lib/kimsin.rb"

ENV["RACK_ENV"] = "test"

class KimsinTests < Test::Unit::TestCase

  include Rack::Test::Methods

  include Capybara::DSL

  def setup
  
    Capybara.app = Sinatra::Application.new

  end
  
  def test_index

    visit "/"

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Login/, last_response.body, "Log in link not present" 

    assert_match /Register/, last_response.body, "Sign up link not present"

  end

  def test_new_user

    visit "/user/new"

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Username/, last_response.body, "Username point not present"

    assert_match /Password/, last_response.body, "Password point not present"

    assert_match /Register/, last_response.body, "Submit button not present"

  end

  def test_create_user

    visit "/user/new"

    fill_in :username, :with => "first@company.com"

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 201, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /Logged in as first@company.com./, last_response.body, "No user created"

    assert_match /Logout/, last_response.body, "Logout link not present"

  end

  def test_same_email

    visit "/user/create"

    fill_in :email, :with => "first@company.com"

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /We already have that email./, last_response.body, "Same email accepted."

  end

  def test_blank_email

    visit "/user/create"

    fill_in :email, :with => ""

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /We need your email address./, last_response.body, "Blank email accepted."

  end

  def test_bad_email

    visit "/user/create"

    fill_in :email, :with => "bademail"

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /Doesn't look like an email adress./, last_response.body, "Badly formatted email accepted."

  end

  def test_blank_password

    visit "/user/create"

    fill_in :email, :with => "second@company.com"

    fill_in :password, :with => ""

    fill_in :confirm_password, :with => ""

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /The password should be 8 to 40 characters long/, last_response.body, "Blank password accepted."
    
  end

  def test_nodigit_password

    visit "/user/create"

    fill_in :email, :with => "second@company.com"

    fill_in :password, :with => "abCabC?*"

    fill_in :confirm_password, :with => "abCabC?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /and contain at least one digit,/, last_response.body, "Password without digits accepted."
    
  end

  def test_noletter_password

    visit "/user/create"

    fill_in :email, :with => "second@company.com"

    fill_in :password, :with => "123123?*"

    fill_in :confirm_password, :with => "123123?*"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /one lowercase and one uppercase letter/, last_response.body, "Password without letters accepted."
    
  end

  def test_nospecialchars_password

    visit "/user/create"

    fill_in :email, :with => "second@company.com"

    fill_in :password, :with => "abC123a1"

    fill_in :confirm_password, :with => "abC123a1"

    click_link "Register"

    error = last_response.errors.split("\n").first

    assert 202, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /and one special character./, last_response.body, "Password without special characters accepted."
    
  end

  def test_login

    visit "/login"

    fill_in :email, :with => "first@company.com"

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"
    
    click_link "Login"

    error = last_response.errors.split("\n").first

    assert 201, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /Logged in as first@company.com./, last_response.body, "No user created"

    assert_match /Logout/, last_response.body, "Logout link not present"

  end

  def test_badlogin

    visit "/login"

    fill_in :email, :with => "third@company.com"

    fill_in :password, :with => "abC123?*"

    fill_in :confirm_password, :with => "abC123?*"
    
    click_link "Login"

    error = last_response.errors.split("\n").first

    assert 201, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /No such user or bad password./, last_response.body, "Bad login accepted."

    assert_match /Login/, last_response.body, "Login page not present."

  end


  def test_logout

    visit "/login"

    fill_in :email, :with => "first@company.com"

    fill_in :password, :with => "abC123?*"

    click_link "Login"

    click_link "Logout"

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Login/, last_response.body, "Log in link not present" 

    assert_match /Register/, last_response.body, "Sign up link not present"
    
  end
  
end
