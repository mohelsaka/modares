class Question < ActiveRecord::Base
  unloadable
  include Surveyor::Models::QuestionMethods

  QUESTION_TYPES = ['text', 'paragraph text', 'multiple choice', 'single choice']
  
  before_save :configre_question
  
  accepts_nested_attributes_for :answers, :allow_destroy => true
  attr_accessible :answers_attributes, :display_type, :text, :type
  
  def type
        
  end
  
  def type=(value)
    @type = value
  end
  
  def configre_question
    # if @type == 'text'
      # self.pick = 'none'
      # self.display_type = 'default'
      # # self.response_class = 'string'
    # elsif @type == 'paragraph text'
      # self.pick = 'none'
      # self.display_type = 'default'
      # # self.response_class = 'text'
    # elsif @type == 'multiple choice'
      # self.pick = 'any'
    # elsif @type == 'multiple choice'
      # self.pick = 'one'
    # end
  end
end