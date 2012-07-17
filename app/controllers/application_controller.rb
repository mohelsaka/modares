class ApplicationController < ActionController::Base
  # before_filter :authenticate_user!
  protect_from_forgery

protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end
  
end
