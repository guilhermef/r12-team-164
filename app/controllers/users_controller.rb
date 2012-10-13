class UsersController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    authentication = User.where(provider: auth['provider'], uid: auth['uid']).first

    if authentication
      flash[:notice] = "Signed in successfully."
    else
      # Authentication not found, thus a new user.
      user = User.new
      user.apply_omniauth(auth)
      if user.save(:validate => false)
        flash[:notice] = "Account created and signed in successfully."
      else
        flash[:error] = "Error while creating a user account. Please try again."
      end
    end
    redirect_to root_url
  end
end
