class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_filter :get_user, :only => [:show, :ready]

  def get_user
    if params[:id] == 'me'
      @user = current_user
    else
      @user = User.where(:uid => params[:id], :registered => true).first
    end
  end

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

  def show
    redirect_to root_url if @user.nil? or !current_user.can_see?(@user.uid)
  end

  def ready
    render(:json => {:ready => @user.data_available?})
  end

  def destroy
    sign_out current_user
    redirect_to root_url
  end
end
