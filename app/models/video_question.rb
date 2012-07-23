class VideoQuestion < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  has_many :video_answers
  
  validates :body, :presence => true

  has_reputation :votes,
    :source => :user,
    :aggregated_by => :sum
      
end
