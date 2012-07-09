class HomeController < ApplicationController
  def index
    @levels = Level.all
  end
end
