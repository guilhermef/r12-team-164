class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

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
    redirect_to user_url(:me)
  end

  def me
    @user = current_user
    render :show
  end

  def show
    @user = User.where(:uid => params[:id], :registered => true).first
    redirect_to root_url if @user.nil? or !current_user.can_see?(@user.uid)
  end

  def destroy
    sign_out current_user
    redirect_to root_url
  end
end
