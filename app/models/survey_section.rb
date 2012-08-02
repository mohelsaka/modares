class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods
  
  accepts_nested_attributes_for :questions, :allow_destroy => true
  attr_accessible :questions_attributes, :title, :description, :video_id
  
  attr_accessor :video_id
    
  before_validation :initialize_display_orders
  
  before_create :create_dummy_survey
  
  attr_protected :survey_id
  
  # Don't Use this "validates :questions, :presence => true"
  # reported bug: http://stackoverflow.com/questions/5144527/nested-models-and-parent-validation
  validate :must_have_questions

  def must_have_questions
    if questions.empty? or questions.all? {|child| child.marked_for_destruction? }
      errors.add(:questions, I18n.translate('survey_section_one_question_at_least'))
    end
  end
  
  def initialize_display_orders
    self.display_order ||= 0
    self.questions.each_with_index{|item, index| item.display_order ||= index+1}
  end
  
  def create_dummy_survey
    dummey_survey = Survey.new(:title => self.title, :video_id => self.video_id)
    dummey_survey.save
    self.survey = dummey_survey
  end
end

