class WelcomeController < ApplicationController

  def index
    return unless current_user

    graph = Koala::Facebook::API.new(current_user.token)
    @checkins = graph.fql_query("SELECT author_uid, checkin_id, tagged_uids, page_id, timestamp FROM checkin WHERE author_uid = me() OR author_uid in (SELECT uid2 FROM friend WHERE uid1 = me()) LIMIT 10000")

    user = current_user
    @checkins.each do |checkin|
      related_users = [checkin['author_uid']] + checkin['tagged_uids']
      next unless related_users.include?(user.uid)

      other_users_ids = related_users - [user.uid]
      other_users = other_users_ids.each do |id|
        other_user = User.where(:uid => id).first

        unless other_user
          user_data = graph.get_object(id)
          other_user = User.create!(:uid => id, :email => user_data['email'], :name => user_data['name'])
        end

        user_checkin = UserCheckin.where(:user1 => user, :user2 => other_user).first
        unless user_checkin
          user_checkin = UserCheckin.create!(:user1 => user, :user2 => other_user)
        end

        if user_checkin.last_timestamp and checkin['timestamp'] <= user_checkin.last_timestamp.to_i
          next
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
          :timestamp => DateTime.parse(Time.at(checkin['timestamp'].to_i).to_s)
        )
        user_checkin.checkin_data.push(checkin_data)
        user_checkin.count = (user_checkin.count || 0) + 1

        user_checkin.save!
      end
    end

    @user = current_user
    @user_checkins = @user.checkins_as_user1
  end
end
