class Video < ActiveRecord::Base
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
  
  belongs_to :subject
  belongs_to :user
  
  has_many :questions
  
  acts_as_votable
  
   has_reputation :votes,
      :source => :user,
      :aggregated_by => :sum
end
