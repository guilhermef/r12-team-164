class User
  include Mongoid::Document
  @queue = :real_life_social_user

  devise :omniauthable, :authenticatable

  field :email, :type => String
  field :name, :type => String
  field :photo_url, :type => String
  field :provider, :type => String
  field :uid, :type => Integer
  field :token, :type => String
  field :registered, :type => Boolean, :default => false

  has_many :checkins_as_user1, :class_name => 'UserCheckin', :inverse_of => :user1
  has_many :checkins_as_user2, :class_name => 'UserCheckin', :inverse_of => :user2

  def apply_omniauth(auth)
    p '***************************'
    p auth
    self.email = auth['extra']['raw_info']['email']
    self.provider = auth['provider']
    self.uid = auth['uid']
    self.token = auth['credentials']['token']
    # self.name = 
    # self.photo_url =
    self.registered = true
  end

end
