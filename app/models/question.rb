class Question < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  has_many :answers
  
  validates :body, :presence => true

  acts_as_votable
  
  has_reputation :votes,
    :source => :user,
    :aggregated_by => :sum
      
end
