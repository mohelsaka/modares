class Video < ActiveRecord::Base
  attr_accessible :icon, :title, :url, :user_id, :subject_id, :description
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
  
  belongs_to :subject
  belongs_to :user
  
  
end
