class ProfilesController < ApplicationController
  def profile
    @user = User.find_by_id(params[:id].to_i)

  end
end
