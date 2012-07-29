class SurveySectionsController < ApplicationController
  before_filter :check_for_sign_in, :only => [:new]
  
  def create
    @section = SurveySection.new(params[:survey_section])
    
    # validate for empty survey sections
    unless @section.valid?
      render :new
      return
    end
    
    # creating a dummey survey if the section is newly created
    unless @section.persisted?
      @dummey_survey = Survey.new(:title => @section.title, :video_id => @section.video_id)
      @dummey_survey.save
      @section.survey = @dummey_survey
    end

    if @section.save
      render :text => 'survey a we bta3 a ya gada3!!! ya raagel ... kabar mo5ak! ;)'
    else
      render :new
    end
  end
  
  def new
    @video = Video.find params[:video_id]

    # check the ownership for the video before adding a homework for it
    if @video.nil? || current_user != @video.user
      flash[:notice] = t('access_denied')
      redirect_to root_url
      return
    end
    
    @section = if @video.survey
      @video.survey.sections.first
    else
      SurveySection.new(:video_id => @video.id)
    end
  end
  
  def update
    @section = SurveySection.find params[:id]
    
    if @section.update_attributes(params[:survey_section])
      render :text => 'survey a we bta3 a ya gada3!!! ya raagel ... kabar mo5ak! ;)'
    else
      render :new
    end
  end
end