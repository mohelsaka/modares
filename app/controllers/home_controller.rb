class HomeController < ApplicationController
  def index
    @resource = User.new  
  end
end
