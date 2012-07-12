class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :get_videos]
  
  def index
    @levels = Level.all
    @subjects = Subject.all
    
    # defualt home page videos
    @videos = Video.find(:all, :order => ['created_at DESC'], :limit => 10)
  end
  
  def get_videos
    @videos = Video.find_all_by_subject_id(params[:subject], :order => ['created_at DESC'])
  end
  
end
