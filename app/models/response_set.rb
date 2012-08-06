class ResponseSet < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ResponseSetMethods
  
  belongs_to :user
  
  # returns the full mark of this excersice.
  # full mark is calculated as the sum of all correct answers in the survey_section
  def full_mark
    full_mark = 0
    self.survey.sections.first.questions.each{|q| full_mark += q.correct_answers.size}
    full_mark
  end
  
  # evaluate all responses, calculate the total mark and save its new value.
  def evaluate_responses!
    # assing the correct marks for the responses
    self.responses.each{|response| response.evaluate_response!}
    
    # calculate the total marks
    # 1- sum correct answers from all questions except MCQs
    mcq_marks = 0
    self.survey.sections.first.questions.find(:all, :conditions => ['question_type = ?', 'multiple_choice']).each do |question|
      mark = self.responses.sum(:correct_flag,
                                :conditions => ['question_id = ?', question.id])
      mcq_marks += mark if mark > 0
    end
    
    # 2- sum correct answers for MCQs
    # in MCQs, wrong answer remove correct one.
    other_questions_marks = self.responses.sum(:correct_flag, 
                                        :joins => :question, 
                                        :conditions => ["questions.question_type != ?", 'multiple_choice'])
    
    # update the total mark with the summation of the two marks
    self.update_attributes(:total_mark => (mcq_marks + other_questions_marks))
  end
  
  
  # returns the time taken to solve the homework
  def elapsed_time
    (self.completed_at - self.started_at)
  end
end