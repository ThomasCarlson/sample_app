class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:error] = "Success!"
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Bogus User!"
      render 'new'
    end
    
                                 
  end

  def destroy
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
