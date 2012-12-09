require 'data_mapper'

require 'dm-validations'

require 'bcrypt'

DataMapper.setup :default, 'sqlite::memory:' 

class User 

  attr_accessor :password, :confirm_password

  attr_reader :password_hash

  include DataMapper::Resource

  property :id, Serial

  property :email, String, :required => true, :unique => true, :format => :email_address,

            :messages => {
            
            :presence => "We need your email address.",

            :is_unique => "We already have that email.",

            :format => "Doesn't look like an email adress."

            }

  property :password_salt, String

  property :password_hash, String, :length => 80

  validates_presence_of :password, :confirm_password, :messages => { :presence => "You have to type a password and confirm it." }

  validates_format_of :password, :confirm_password, :with => /(?=^.{8,}$)(?=.*\d)(?=.*\W+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/,

  										:messages => { :format => "The password should be at least 8 characters long, contain one lowercase, one uppercase letter, one digit and one special character." }

  before :save, :encrypt_password

  def self.authenticate email, password

    user = User.first :email => email

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)

      user

    else

      nil

    end

  end

  def encrypt_password

    if password != nil

      self.password_salt = BCrypt::Engine.generate_salt

      self.password_hash = BCrypt::Engine.hash_secret password, password_salt

    end

  end

end

DataMapper.finalize
