class VideoAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :body, :presence => true

  has_reputation :votes,
      :source => :user,
      :aggregated_by => :sum
      
end
