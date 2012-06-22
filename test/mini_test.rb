require "test/unit"

require "minitest/autorun"

require "rack/test"

require_relative "../lib/kimsin.rb"

ENV["RACK_ENV"] = "test"

class KimsinTests < MiniTest::Unit::TestCase

  i_suck_and_my_tests_are_order_dependent!

  include Rack::Test::Methods

  def app

      Kimsin.new

  end
  
  def test_index

    get "/"

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Login/, last_response.body, "Log in link not present" 

    assert_match /Register/, last_response.body, "Sign up link not present"

  end

  def test_login

    get "/login"
    
    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Username/, last_response.body, "Username point not present"

    assert_match /Password/, last_response.body, "Password point not present"

    assert_match /Login/, last_response.body, "Login link not present"

  end

  def test_new_user

    get "/user/new"

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Username/, last_response.body, "Username point not present"

    assert_match /Password/, last_response.body, "Password point not present"

    assert_match /Register/, last_response.body, "Submit button not present"

  end

  def test_create_user

    post "/user/create", :email => "first@company.com", :password => "abC123?*", :confirm_password => "abC123?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /Logged in as first@company.com./, last_response.body, "No user created"

    assert_match /Logout/, last_response.body, "Logout link not present"

  end

  def test_same_email

    post "/user/create", :email => "first@company.com", :password => "abC123?*", :confirm_password => "abC123?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /We already have that email./, last_response.body, "Same email accepted."

  end

  def test_blank_email

    post "/user/create", :email => "", :password => "abC123?*", :confirm_password => "abC123?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /We need your email address./, last_response.body, "Blank email accepted."

  end

  def test_bad_email

    post "/user/create", :email => "bademail", :password => "abC123?*", :confirm_password => "abC123?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /Doesn't look like an email adress./, last_response.body, "Badly formatted email accepted."

  end

  def test_blank_password

    post "/user/create", :email => "second@company.com", :password => "", :confirm_password => ""

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /assword must not be blank/, last_response.body, "Blank password accepted."
    
  end

  def test_nodigit_password

    post "/user/create", :email => "second@company.com", :password => "abCabC?*", :confirm_password => "abCabC?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /assword has an invalid format/, last_response.body, "Password without digits accepted."
    
  end

  def test_noletter_password

    post "/user/create", :email => "second@company.com", :password => "123123?*", :confirm_password => "123123?*"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /assword has an invalid format/, last_response.body, "Password without letters accepted."
    
  end

  def test_nospecialchars_password

    post "/user/create", :email => "second@company.com", :password => "abC123a1", :confirm_password => "abC123a1"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 202 expected but was #{last_response.status}.\n#{error}"

    assert_match /assword has an invalid format/, last_response.body, "Password without special characters accepted."
    
  end

  def test_goodlogin

    post "/login", :email => "first@company.com", :password => "abC123?*"
    
    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /Logged in as first@company.com./, last_response.body, "No user created"

    assert_match /Logout/, last_response.body, "Logout link not present"

  end

  def test_badlogin

    post "/login", :email => "third@company.com", :password => "abC123?*"
    
    follow_redirect!

    error = last_response.errors.split("\n").first

    assert_equal 200, last_response.status, "Status 201 expected but was #{last_response.status}.\n#{error}"

    assert_match /No such user or bad password./, last_response.body, "Bad login accepted."

    assert_match /Login/, last_response.body, "Login page not present."

  end


  def test_logout

    post "/login", :email => "first@company.com", :password => "abC123?*"

    follow_redirect!

    get "/session/destroy"

    follow_redirect!

    error = last_response.errors.split("\n").first

    assert last_response.ok?, "Status 200 expected but was #{last_response.status}.\n#{error}"

    assert_match /Login/, last_response.body, "Log in link not present" 

    assert_match /Register/, last_response.body, "Sign up link not present"
    
  end
  
end
