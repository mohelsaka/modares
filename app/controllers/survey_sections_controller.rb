class SurveySectionsController < ApplicationController
  
  # POST /videos
  # POST /videos.json
  def create
    @survey_section = SurveySection.new(params[:survey_section])
    
    @dummey_survey = Survey.new
    @dummey_survey.title = @survey_section.title
    @dummey_survey.save
    
    @survey_section.survey = @dummey_survey
    @survey_section.save
    
    debugger
    
    puts @survey_section.inspect
    
    render :text => 'survey a we bta3 a ya gada3!!! ya raagel ... kabar mo5ak! ;)'

    # respond_to do |format|
      # if @video.save
        # format.html { redirect_to @video, notice: 'Video was successfully created.' }
        # format.json { render json: @video, status: :created, location: @video }
      # else
        # format.html { render action: "new" }
        # format.json { render json: @video.errors, status: :unprocessable_entity }
      # end
    # end
  end
  
end