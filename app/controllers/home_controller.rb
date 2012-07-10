class HomeController < ApplicationController
  def index
    @levels = Level.all
    @subjects = Subject.all
    @videos = Video.all
  end
end
