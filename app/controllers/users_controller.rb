class UsersController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    user = User.where(uid: auth['uid']).first

    if user
      flash[:notice] = "Signed in successfully."
    else
      user = User.new
      flash[:notice] = "Account created and signed in successfully."
    end

    user.apply_omniauth(auth)
    user.processing = true
    user.save!
    Resque.enqueue(User, user.id)

    sign_in user
    redirect_to user_url(user.uid)
  end

  def show
    redirect_to root_url unless current_user
  end

  def destroy
    sign_out current_user
    redirect_to root_url
  end
end
