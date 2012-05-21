require "test/unit"
require "minitest/autorun"
require "rack/test"
require_relative "../lib/kimsin.rb"

ENV['RACK_ENV'] = 'test'

class KimsinTests < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
  end
end    
