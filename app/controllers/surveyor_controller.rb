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
    else
      @survey = Survey.find_by_access_code(params[:survey_code])
      response_set_code = ResponseSet.where(:user_id => current_user.id, :survey_id => @survey.id).first.try(:access_code)
      
      response_set_code = ResponseSet.create(:survey => @survey, :user_id => current_user.id).access_code unless response_set_code
      
      redirect_to edit_my_survey_url(:survey_code => @survey.access_code, :response_set_code => response_set_code)
    end
  end
  def update
    super
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
end
