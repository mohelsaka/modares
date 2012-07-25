class ProfilesController < ApplicationController
  def profile
    if params[:id]
      @user = User.find(params[:id])
    elsif user_signed_in?
      @user = current_user
    end  
  end
end
