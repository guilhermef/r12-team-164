class UserCheckin
  include Mongoid::Document

  field :count, :type => Integer
  field :last_timestamp, :type => DateTime

  belongs_to :user1, :class_name => 'User', :inverse_of => :checkins_as_user1
  belongs_to :user2, :class_name => 'User', :inverse_of => :checkins_as_user2

  embeds_many :checkin_data

  def month_count
    groups = checkin_data.group_by { |d| "#{d.timestamp.year}_#{d.timestamp.month}" }
    current_month = Time.now.month
    current_year = Time.now.year

    ((current_month - 11)..current_month).map do |month|
      year = current_year
      if month <= 0
        month = 12 + month
        year -= 1
      end

      (groups["#{year}_#{month}"] || []).size
    end
  end

end
