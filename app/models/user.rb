class User < ActiveRecord::Base

  
      # t.string :email
      # t.string :user_name
      # t.string :first_name
      # t.string :last_name
      # t.string :password_hash
      # t.timestamps
  has_many :rounds
  has_many :decks, :through => :rounds

  validates :user_name, :presence => true, :uniqueness

  validates :email, :presence => true



  include BCrypt

  def password
    @password ||= Password.new(self.password_hash)
  end
  
  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.create(options={})
    @user = User.new(:email => options[:email])
    @user.password = options[:password]
    @user.save!
    @user
  end

  def self.authenticate(params)
    @user = User.find_by_email(params[:email])
    (@user && @user.password == params[:password]) ? @user : false
  end


end
