class SurveySectionsController < ApplicationController
  
  # POST /videos
  # POST /videos.json
  def create
    @survey_section = SurveySection.new(params[:survey_section])
    
    # validate for empty survey sections
    if @survey_section.questions.empty?
      flash[:notice] = t('.should_enter_questions')
      redirect_to :action => :new
      return
    end
    
    @dummey_survey = Survey.new
    @dummey_survey.title = @survey_section.title
    @dummey_survey.save
    
    @survey_section.survey = @dummey_survey
    @survey_section.save
    
    puts @survey_section.inspect
    
    render :text => 'survey a we bta3 a ya gada3!!! ya raagel ... kabar mo5ak! ;)'
  end
  
  def new
    @section = SurveySection.new
  end
  
end