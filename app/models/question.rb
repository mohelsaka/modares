class Question < ActiveRecord::Base
  unloadable
  include Surveyor::Models::QuestionMethods

  QUESTION_TYPES = ['multiple_choice', 'single_choice', 'short_answer_question']
  CORRECT_ANSWER_TAG_TYPE =  {'multiple_choice' => 'checkbox', 'single_choice' => 'radio', 'short_answer_question' => 'text'}
  
  before_validation :initialize_display_orders
  before_save :configre_question
  
  accepts_nested_attributes_for :answers, :allow_destroy => true
  attr_accessible :answers_attributes, :display_type, :text, :question_type
  
  # validate the number of answers in for each type of questions
  # e.g. choice questions should have more than one choice.
  validate :validate_num_of_answers
  
  # this function applys the configration for each question type
  # for more information check surveyor gem : file doc/question_types.png
  def configre_question
    if question_type == 'short_answer_question'
      self.pick = 'none'
      self.display_type = 'default'
      self.answers.each{|answer| answer.response_class = 'string'}

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
  
private
  def validate_num_of_answers
    if ['multiple_choice', 'single_choice'].include? question_type && answers.size < 2
      errors.add(:answers, 'Must have at least two answers')
    elsif question_type == 'short_answer_question' && answers.size < 1
      errors.add(:answers, 'Yout must provide at least one short question.')
    end
  end
  
end