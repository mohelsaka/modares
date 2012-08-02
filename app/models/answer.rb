class Answer < ActiveRecord::Base
  unloadable
  include Surveyor::Models::AnswerMethods
  
  attr_protected :question_id
end
