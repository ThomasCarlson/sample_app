class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:edit, :update]
  before_action :correct_user,  only: [:edit, :update]
  
  def logged_in_user
    unless logged_in?
      store_desired_url
      flash[:error] = "Please log in to access this page."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      (params[:session] && params[:session][:remember_me]) == '1' ? remember(@user) : forget(@user)
      flash[:success] = "created user #{@user.name}"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash[:error] = "Invalid update data"
      render 'edit'
    end
  end  

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
