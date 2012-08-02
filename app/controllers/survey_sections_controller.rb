class SurveySectionsController < ApplicationController
  before_filter :authenticate_user!
    
  def create
    video = current_user.videos.find params[:survey_section][:video_id]
    
    @section = SurveySection.new(params[:survey_section])
    
    if @section.save
      flash[:notice] = t('.homework_saved')
      redirect_to video_path(@section.survey.video.id)
    else
      render :new
    end
  end
  
  def new
    @video = current_user.videos.find params[:video_id]

    @section = if @video.survey
      @video.survey.sections.first
    else
      SurveySection.new(:video_id => @video.id)
    end
  end
  
  def update
    @section = SurveySection.find params[:id]
    video = current_user.videos.find @section.survey.video_id
    
    if @section.update_attributes(params[:survey_section])
      flash[:notice] = t('.homework_saved')
      redirect_to video_path(@section.survey.video.id)
    else
      render :new
    end
  end
end