class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods
  
  belongs_to :video
  
end