class Video < ActiveRecord::Base
  attr_accessible :icon
  has_attached_file :icon ,:styles =>{:medium => "300x300>", :thumb => "100x100>" }
end
