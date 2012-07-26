class Question < ActiveRecord::Base
  unloadable
  include Surveyor::Models::QuestionMethods

  QUESTION_TYPES = ['multiple choice', 'single choice', 'text', 'paragraph text']
  
  before_save :configre_question
  
  accepts_nested_attributes_for :answers, :allow_destroy => true
  attr_accessible :answers_attributes, :display_type, :text, :type
  
  def type
        
  end
  
  def type=(value)
    @type = value
  end
  
  def configre_question
    puts '######################## reconfigre'
    if @type == 'text'
      self.pick = 'none'
      self.display_type = 'default'
      # self.answers.clear
      answer = self.answers.build :response_class => 'string', :display_order => 0, :text => 'Answer'
      answer.save
    elsif @type == 'paragraph text'
      self.pick = 'none'
      # self.answers.clear
      answer = self.answers.build :response_class => 'text', :display_order => 0, :text => 'Answer'
      answer.save
      self.display_type = 'default'
    elsif @type == 'multiple choice'
      self.pick = 'any'
    elsif @type == 'single choice'
      self.pick = 'one'
    end
  end
end