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
  field :last_timestamp, :type => Integer
  field :processing, :type => Boolean, :default => false

  has_many :checkins_as_user1, :class_name => 'UserCheckin', :inverse_of => :user1
  has_many :checkins_as_user2, :class_name => 'UserCheckin', :inverse_of => :user2

  def apply_omniauth(auth)
    self.email = auth['extra']['raw_info']['email']
    self.provider = auth['provider']
    self.uid = auth['uid']
    self.token = auth['credentials']['token']
    self.name = auth['info']['name']
    self.photo_url = auth['info']['image']
    self.registered = true
  end

  def picture
    "http://graph.facebook.com/#{uid}/picture"
  end

  def large_picture
    picture + '?type=large'
  end

  def self.perform(user_id)
    user = User.find(user_id)

    graph = Koala::Facebook::API.new(user.token)
    @checkins = graph.fql_query(<<-EOF
      SELECT author_uid, checkin_id, tagged_uids, page_id, timestamp
      FROM checkin
      WHERE
        author_uid = me() OR
        author_uid in (SELECT uid2 FROM friend WHERE uid1 = me())
      LIMIT 10000
    EOF
    )

    if user.last_timestamp
      @checkins.filter { |checkin| checkin['timestamp'].to_i > user.last_timestamp }
    end
    last_timestamp = 0

    @checkins.each do |checkin|
      related_users = [checkin['author_uid']] + checkin['tagged_uids']
      next unless related_users.include?(user.uid)

      other_users_ids = related_users - [user.uid]
      other_users = other_users_ids.each do |id|
        id = id.to_i
        other_user = User.where(:uid => id).first

        unless other_user
          user_data = graph.fql_query("SELECT uid, name, pic_square FROM user WHERE uid = #{id}")[0]
          other_user = User.create!(:uid => id, :name => user_data['name'], :photo_url => user_data['pic_square'])
        end

        user_checkin = UserCheckin.where(:user1 => user, :user2 => other_user).first
        unless user_checkin
          user_checkin = UserCheckin.create!(:user1 => user, :user2 => other_user)
        end

        timestamp = checkin['timestamp'].to_i
        if timestamp > last_timestamp
          last_timestamp = timestamp
        end

        place_data = graph.get_object(checkin['page_id'])
        place_data['location'] = place_data['location'] || {}
        checkin_data = CheckinData.new(
          :place_name => place_data['name'],
          :place_long => place_data['location']['longitude'],
          :place_lat => place_data['location']['latitude'],
          :place_link => place_data['link'],
          :place_category => place_data['category'],
          :checkin_id => checkin['checkin_id'],
          :page_id => checkin['page_id'],
          :timestamp => DateTime.parse(Time.at(timestamp).to_s)
        )
        user_checkin.checkin_data.push(checkin_data)
        user_checkin.count = (user_checkin.count || 0) + 1

        user_checkin.save!
      end
    end

    user.processing = false
    user.last_timestamp = last_timestamp
    user.save!
  end

end
