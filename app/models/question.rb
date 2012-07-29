class Question < ActiveRecord::Base
  unloadable
  include Surveyor::Models::QuestionMethods

  QUESTION_TYPES = ['multiple_choice', 'single_choice', 'short_answer_question', 'paragraph_text']
  
  before_validation :initialize_display_orders
  before_save :configre_question
  
  accepts_nested_attributes_for :answers, :allow_destroy => true
  attr_accessible :answers_attributes, :display_type, :text, :question_type
  
  def configre_question
    if question_type == 'short_answer_question'
      self.pick = 'none'
      self.display_type = 'default'
      self.answers.each{|answer| answer.response_class = 'string'}

    elsif question_type == 'paragraph_text'
      self.pick = 'none'
      self.answers.clear
      answer = self.answers.build :response_class => 'text', :display_order => 0, :text => 'Answer'
      answer.save
      self.display_type = 'default'

    elsif question_type == 'multiple_choice'
      self.pick = 'any'

    elsif question_type == 'single_choice'
      self.pick = 'one'
    end
  end
  
  def initialize_display_orders
    order = 1
    answers.each{|answer| answer.display_order = (order += 1) unless answer.display_order}
  end
end