class HomeController < ApplicationController
  def index
    @levels = Level.all
    @subjects = Subject.all
  end
end
