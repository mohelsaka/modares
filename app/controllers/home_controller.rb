class HomeController < ApplicationController
  def index
    @levels = Level.all
    @subjects = Subject.all
    @videos = Video.all
  end
  
  def get_videos
    @videos = Video.find_all_by_subject_id(params[:subject])
    
    # @videos = Video.all
    # render :js => "alert('Blah')"
    # respond_to do |format|
       # format.js do
          # render :update do |page|
            # puts "##################################"
            # page.replace_html 'videos-list', :partial => 'videos/video_thumb', :collection => @videos
          # end
       # end
     # end
   
  end
end
