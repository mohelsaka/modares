class Answer < ActiveRecord::Base
  unloadable
  include Surveyor::Models::AnswerMethods
  
  attr_protected :question_id
  
  before_save :assign_custom_class
  
  def cast_correct_answer
    question_type = self.question.question_type
    
    if question_type == 'multiple_choice' || question_type == 'single_choice'
      self.correct_answer == 'on'
    elsif question_type == 'short_answer_question'
      self.correct_answer
    end
  end
  
  def assign_custom_class
    self.custom_class = if self.correct_answer == 'on'
      'correct_ans'
    else
      ''
    end
  end
end
