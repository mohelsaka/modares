class ApplicationController < ActionController::Base
  include ActionView::Helpers::JavaScriptHelper
  
  # before_filter :authenticate_user!
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    display_error_popup(@error_place, exception.message)
  end
  
protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end
  
  def display_error_popup(id, message)
    render :js => "dispalyPop('##{id}', '#{escape_javascript message}');"
  end
end
