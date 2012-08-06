class Response < ActiveRecord::Base
  unloadable
  include ActionView::Helpers::SanitizeHelper
  include Surveyor::Models::ResponseMethods
  
  # evaluate this response according to the type of its question
  def evaluate_response!
    a = self.answer
    q = self.question
      
    correct_mark = case q.question_type
      when'multiple_choice'
        # wrong answer will remove correct one from the same question
        a.correct_answer == 'on' ? 1 : -1
      when 'single_choice'
        a.correct_answer == 'on'
      when 'short_answer_question'
        a.correct_answer.strip == self.string_value.strip
      else
        0
      end
    
    self.update_attributes(:correct_flag => correct_mark)
  end
  
  def wrong?
    self.correct_flag != 1
  end
end
