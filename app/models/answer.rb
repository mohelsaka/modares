class Answer < ActiveRecord::Base
  belongs_to :question
  
  acts_as_votable
end
