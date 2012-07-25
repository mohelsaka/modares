class Video < ActiveRecord::Base
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
  attr_protected :views
  belongs_to :subject
  belongs_to :user
  
  has_many :questions
  
   has_reputation :votes,
      :source => :user,
      :aggregated_by => :sum
  
  validates :title, :presence => true
  validates :user_id, :presence => true
  validates :subject_id, :presence => true
  def image
    "http://i.ytimg.com/vi/#{url}/mqdefault.jpg"
  end    
  def video_views
    (User::CLIENT).my_video(url).view_count
    # url
  end
  
  def video_duration
    (User::CLIENT).my_video(url).duration
  end
end
