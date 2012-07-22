class ApplicationController < ActionController::Base
  # before_filter :authenticate_user!
  protect_from_forgery

protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end

  # overwriting after_sign_in_path_for of devise gem to return the user to the same location after sign in
  def after_sign_in_path_for(resource)
    session[:return_to] || ''
  end
end
