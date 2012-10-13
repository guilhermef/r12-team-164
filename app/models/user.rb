class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :authenticatable

  field :email, :type => String

  field :provider, :type => String
  field :uid, :type => String
  field :token, :type => String

  def apply_omniauth(auth)
    self.email = auth['extra']['raw_info']['email']
    self.provider = auth['provider']
    self.uid = auth['uid']
    self.token = auth['credentials']['token']
  end

end
