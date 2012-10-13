class WelcomeController < ApplicationController
  def index
    return unless current_user

    @user = current_user
    @user_checkins = @user.checkins_as_user1
  end
end
