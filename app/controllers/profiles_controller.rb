class ProfilesController < ApplicationController
  def profile
    @user = User.find(params[:id])
    
    # Get the user's reputations
    @reputations = RSEvaluation.where('target_owner_id'=> @user.id)    
  end
end
