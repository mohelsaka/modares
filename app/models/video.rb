class Video < ActiveRecord::Base
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
  
  belongs_to :subject
  belongs_to :user
  
  has_many :questions
  
  has_many :video_view
  
  acts_as_votable
end
