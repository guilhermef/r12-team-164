module WelcomeHelper
  def users_total
    User.count
  end

  def checkins_total
    User.all.inject(0){|sum, u| u.checkins_as_user1.count + sum}
  end
end
