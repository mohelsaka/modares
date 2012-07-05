class Semester < ActiveRecord::Base
  belongs_to :level
  has_many :subjects
end
