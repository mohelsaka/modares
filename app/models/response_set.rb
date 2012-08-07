class ResponseSet < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ResponseSetMethods
  
  belongs_to :user
  
  # returns the full mark of this excersice.
  # full mark is calculated as the number of questions in the survey_section
  def full_mark
    self.survey.sections.first.questions.size
  end
  
  # evaluate all responses, calculate the total mark and save its new value.
  def evaluate_responses!
    # assing the correct marks for the responses
    self.responses.each{|response| response.evaluate_response!}
    
    # calculate mark for each question
    mark = self.survey.sections.first.questions.inject(0.0){|value, q| value += q.evaluate_responses(self.responses.where(:question_id => q.id))}
    
    # update the value of total mark
    self.update_attributes(:total_mark => mark)
  end
  
  
  # returns the time taken to solve the homework
  def elapsed_time
    (self.completed_at - self.started_at)
  end
end