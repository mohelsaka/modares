class Video < ActiveRecord::Base
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
  
  belongs_to :subject
  belongs_to :user
  
  # destroy questions on destroying video
  has_many :questions, :dependent => :destroy
end
