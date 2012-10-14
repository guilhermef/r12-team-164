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
