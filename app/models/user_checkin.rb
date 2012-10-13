

class CheckinData
  include Mongoid::Document

  field :place_name, :type => String
  field :place_long, :type => String
  field :place_lat, :type => String
  field :place_link, :type => String
  field :place_category, :type => String

  field :checkin_id, :type => String
  field :page_id, :type => String
  field :timestamp, :type => DateTime
  embedded_in :user_checkin

end

class UserCheckin
  include Mongoid::Document

  field :count, :type => Integer
  field :last_timestamp, :type => DateTime

  belongs_to :user1, :class_name => 'User', :inverse_of => :checkins_as_user1
  belongs_to :user2, :class_name => 'User', :inverse_of => :checkins_as_user2

  embeds_many :checkin_data

end