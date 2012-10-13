class WelcomeController < ApplicationController
  def index
    if current_user
      graph = Koala::Facebook::GraphAPI.new(current_user.token)
      @checkins = graph.fql_query("SELECT author_uid, checkin_id, tagged_uids, page_id, timestamp FROM checkin WHERE author_uid in (SELECT uid2 FROM friend WHERE uid1 = me())")
    end
  end
end
