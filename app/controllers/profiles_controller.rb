class ProfilesController < ApplicationController
  def profile
    @user = User.find(params[:id])
    puts request.env['omniauth.auth'].inspect
  end
end
