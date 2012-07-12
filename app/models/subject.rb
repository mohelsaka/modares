class Subject < ActiveRecord::Base
  belongs_to :semester
  has_many :videos
end
