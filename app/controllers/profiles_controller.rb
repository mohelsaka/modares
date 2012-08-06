class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :only =>[:private_score]
  def profile
    @user = User.find(params[:id])
    puts request.env['omniauth.auth'].inspect
  end
  
  def private_score
    
    current_user.score_private = !current_user.score_private
    current_user.save
    if current_user.score_private
      render :js => "$('#score').html('Public');$('#private-link').html('Make your score private');"
    else
      render :js => "$('#score').html('Private');$('#private-link').html('Make your score public');"
    end 
   
  end
    
end
