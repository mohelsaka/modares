class Level < ActiveRecord::Base
  default_scope :order =>"position asc"
  has_many :semesters
end
