require "sinatra"

require "erb"

require_relative "../lib/kimsin/version"

require_relative "../lib/kimsin/user"

module Kimsin

  use Rack::Session::Pool, :expire_after => 2592000

  set :session_secret, BCrypt::Engine.generate_salt

  configure :development do  

    DataMapper.auto_migrate!  

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

    session[:errors] = session[:errors] || nil

    erb :new, :locals => { :errors => session[:errors] }

  end

  post "/user/create" do

    user = User.new :email => params[:email], :password => params[:password], :confirm_password => params[:confirm_password]

    if user.save

      status 201

      session[:errors] = nil

      session[:user_id] = user.id

      redirect "/"

    else

      status 412

      session[:errors] = user.errors

      redirect "/user/new"

    end

  end

  get "/login" do

    session[:errors] = session[:errors] || nil

    erb :login, :locals => { :errors => session[:errors] }
  
  end

  post "/login" do

    user = User.authenticate params[:email], params[:password]

    if user

      status 201

      session[:errors] = nil

      session[:user_id] = user.id

      redirect "/"

    else

      status 202

      session[:errors] = "No such user or bad password."

      redirect "/login"

    end
  
  end

  get "/session/destroy" do

    session[:user_id] = nil

    redirect "/"
  
  end

  def current_user

    current_user ||= User.find(session[:user_id]) if session[:user_id]

  end

end
