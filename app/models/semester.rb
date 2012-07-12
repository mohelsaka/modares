class Semester < ActiveRecord::Base
  default_scope :order =>"position asc"
  
  belongs_to :level
  has_many :subjects
end
