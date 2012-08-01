class ApplicationController < ActionController::Base
  include ActionView::Helpers::JavaScriptHelper
  
  # before_filter :authenticate_user!
  before_filter :get_redirect_path
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    display_error_popup(@error_place, exception.message)
  end
  
  def get_redirect_path
    puts request.referer
    # if (request.fullpath == new_user_session_path || request.fullpath == new_user_registration_path || request.fullpath == users_path)
      # session[:return_to] = root_url  
    # else
      # session[:return_to] = request.fullpath
    # end
    # puts session[:return_to]
  end
protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end
  
  def display_error_popup(id, message)
    render :js => "dispalyPop('##{id}', '#{escape_javascript message}');"
  end

  # overwriting after_sign_in_path_for of devise gem to return the user to the same location after sign in
  def after_sign_in_path_for(resource)
    puts request.fullpath
    if (request.fullpath =~ %r"/users") != 0 && (request.fullpath =~ %r"/admins") != 0 
      request.fullpath
    else
      ''
    end  
  end
end
