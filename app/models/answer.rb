class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :body, :presence => true

  acts_as_votable
  
  has_reputation :avg_rating,
      :source => :user,
      :aggregated_by => :average,
      :source_of => [{ :reputation => :answering_skill, :of => :author }]
      
end
