class ApplicationController < ActionController::Base
  # before_filter :authenticate_user!
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    voteType = params[:type] == 'like' ? 'up' : 'down'
    render :js => "dispalyPop('##{params[:target] + params[:id]}-votes-#{voteType}', '#{exception.message}');"    
    # render :js => "$('#error-msg').html('#{exception.message}').parent().removeClass('hidden');"
  end
  
protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end
  
end
