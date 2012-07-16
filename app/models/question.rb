class Question < ActiveRecord::Base
  belongs_to :video
  has_many :answers, :dependant => :destroy
end
