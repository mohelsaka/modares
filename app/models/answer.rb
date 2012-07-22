class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :body, :presence => true

  has_reputation :votes,
      :source => :user,
      :aggregated_by => :average,
      :source_of => [{ :reputation => :answering_skill, :of => :author }]
      
end
