class Subject < ActiveRecord::Base
  default_scope :order =>"position asc"
  
  belongs_to :semester
  has_many :videos
end
