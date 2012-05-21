require "sinatra"
require "erb"
require_relative "../lib/kimsin/version"

use Rack::Session::Pool, :expire_after => 2592000
set :session_secret, "n9c0431qt043fcwo4ponm3w5483qprutc3q9pfw3r0swaypedx2qafec2qdomvuj8cy4nawscerf"

module Kimsin
  get "/" do
    title = "Anasayfa"
    erb :index, :locals => {:title => title}
  end

end
