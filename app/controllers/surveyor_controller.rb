module SurveyorControllerCustomMethods
  
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end

  # Actions
  def new
    super
    # @title = "You can take these surveys"
  end
  def create
    super
  end
  def show
    super
  end
  
  # this action checks if the user have already taken this survey then displaying his response
  # else create new empty response
  def edit
    if params[:response_set_code]
      super
      @finished = !@response_set.completed_at.nil?
    else
      @survey = Survey.find_by_access_code(params[:survey_code])
      
      # retriving the response_set_code of from the existing one of creating new response_set
      response_set_code = ResponseSet.where(:user_id => current_user.id, :survey_id => @survey.id).first.try(:access_code)
      response_set_code ||= ResponseSet.create(:survey => @survey, :user_id => current_user.id).access_code
      
      redirect_to edit_my_survey_url(:survey_code => @survey.access_code, :response_set_code => response_set_code)
    end
  end
  
  def update
    saved = false
    ActiveRecord::Base.transaction do
      @response_set = current_user.response_sets.find_by_access_code(params[:response_set_code], :include => {:responses => :answer}, :lock => true)
      
      # ensure that user can't take the exercise more than once
      if !@response_set.blank? && @response_set.completed_at.nil?
        saved = @response_set.update_attributes(:responses_attributes => ResponseSet.to_savable(params[:r]))
        @response_set.complete! if saved && params[:finish]
        @response_set.evaluate_responses!
        saved &= @response_set.save
      end
    end
    
    # preparing objects needed by :edit view
    @survey = @response_set.survey
    @section = @survey.sections.first
    @finished = true
    
    flash[:notice] = t('surveyor.completed_survey')
    render :edit
  end
  
  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    super # available_surveys_path
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
  layout "application"
  before_filter :authenticate_user!
end
