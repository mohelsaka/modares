class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods
  
  accepts_nested_attributes_for :questions, :allow_destroy => true
  attr_accessible :questions_attributes, :title, :description
  
  before_validation :initialize_display_orders
  
  def initialize_display_orders
    self.display_order = 0 if self.display_order.nil?
    order = 1
    questions.each{|question| question.display_order = (order += 1) unless question.display_order}
  end
end

