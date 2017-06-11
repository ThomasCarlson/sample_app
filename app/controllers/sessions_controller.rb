class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:info] = "Success!"
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      
      redirect_back_or user
    else
      flash.now[:danger] = "Bogus User!"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
