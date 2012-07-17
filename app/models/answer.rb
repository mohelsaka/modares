class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :body, :presence => true

  acts_as_votable
end
