require "sinatra/base"
require "erb"
require_relative "../lib/kimsin/version.rb"
require_relative "../lib/kimsin/user.rb"

class Kimsin < Sinatra::Base
  use Rack::Session::Pool, :expire_after => 2592000
  set :session_secret, BCrypt::Engine.generate_salt

  configure :development, :test do  
    DataMapper.auto_migrate!  
  end

  configure :production do  
    DataMapper.auto_update!  
  end

  get "/" do
    if session[:user_id]
      user = User.get session[:user_id]
      email = user.email
      erb :index, :locals => { :email => email }
    else
      email = nil
      erb :index, :locals => { :email => email }
    end      
  end

  get "/user/new" do
    session[:errors] = session[:errors]
    erb :new, :locals => { :errors => session[:errors] }
  end
  post "/user/create" do
    user = User.new :email => params[:email], :password => params[:password], :confirm_password => params[:confirm_password]
    if user.save
      session[:errors] = nil
      session[:user_id] = user.id
      redirect "/"
    else
      session[:errors] = user.errors
      redirect "/user/new"
    end
  end

  get "/login" do
    session[:errors] = session[:errors]
    erb :login, :locals => { :errors => session[:errors] }
  end

  post "/login" do
    user = User.authenticate params[:email], params[:password]
    if user
      session[:errors] = nil
      session[:user_id] = user.id
      redirect "/"
    else
      session[:errors] = "No such user or bad password."
      redirect "/login"
    end
  end

  get "/session/destroy" do
    session[:user_id] = nil
    redirect "/"
   end

  run! if app_file == $0
end
