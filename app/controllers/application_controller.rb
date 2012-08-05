class ApplicationController < ActionController::Base
  before_filter :save_cookies
  protect_from_forgery


  def save_cookies
    if(cookies[:videoId])
      video_view = VideoView.where("user_id = ? AND video_id = ?", current_user.id,  cookies[:videoId] ).first
      current_watch_percentage = video_view.watch_percentage
      if(current_watch_percentage < (cookies[:videoWatchPercent]).to_i )
        video_view.update_attributes(:watch_percentage => (cookies[:videoWatchPercent]).to_i)
      end
      cookies.delete :videoId

      
    end
  end
protected
  def check_for_sign_in
    render :js => "$('#login-popup').addClass('open'); $('#signin-required').removeClass('hide');" unless user_signed_in?
  end
  
end
