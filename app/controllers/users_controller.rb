class UsersController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    user = User.where(uid: auth['uid']).first

    if user
      flash[:notice] = "Signed in successfully."
    else
      # Authentication not found, thus a new user.
      user = User.new
      user.apply_omniauth(auth)
      if user.save(:validate => false)
        flash[:notice] = "Account created and signed in successfully."
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url and return
      end
    end

    Resque.enqueue(User, user.id)

    sign_in user
    redirect_to user_url
  end

  def show
  end
end
