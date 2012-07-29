class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods
  
  accepts_nested_attributes_for :questions, :allow_destroy => true
  attr_accessible :questions_attributes, :title, :description, :video_id
  
  attr_accessor :video_id
    
  before_validation :initialize_display_orders
  
  # Don't Use this "validates :questions, :presence => true"
  # reported bug: http://stackoverflow.com/questions/5144527/nested-models-and-parent-validation
  validate :must_have_questions

  def must_have_questions
    if questions.empty? or questions.all? {|child| child.marked_for_destruction? }
      errors.add(:questions, 'Must have at least one question!')
    end
  end
  
  def initialize_display_orders
    self.display_order = 0 if self.display_order.nil?
    order = 1
    questions.each{|question| question.display_order = (order += 1) unless question.display_order}
  end
end

