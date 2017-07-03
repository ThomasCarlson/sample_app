class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in_user
    unless logged_in?
      store_desired_url
      flash[:error] = "Please log in to access this page."
      redirect_to login_url
    end
  end

  include SessionsHelper
end
