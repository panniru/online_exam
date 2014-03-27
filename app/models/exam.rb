WillPaginate.per_page = 15
class Exam < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:subject, :exam_name]

  validates :course_id, :presence => true
  validates :subject, :presence => true
  validates :exam_name, :presence => true
  validates :duration, :presence => true
  validates :no_of_questions, :presence => true
  validates :negative_mark, numericality: { only_float: true }
  validates :pass_criteria_1, :presence => true, numericality: { only_float: true }
  validates :pass_text_1, :presence => true
#  validate :pass_criteria
  before_save :set_default_nagative_mark

  has_many :multiple_choice_questions, :dependent => :destroy
  has_many :descriptive_questions, :class_name => "DescriptiveQuestion", :dependent => :destroy
  has_many :registraions
  belongs_to :course
  has_many :schedules, :dependent => :destroy

  scope :search_by_name, lambda{|name| where(:exam_name => name)}
  scope :belongs_to_faculty, lambda{|faculty| where(:faculty_id => faculty)}
  scope :belongs_to_course, lambda{|course_id| where(:course_id => course_id)}

  def new_multiple_choice_question
    mc_question = MultipleChoiceQuestion.new
    mc_question.audio_video_question = AudioVideoQuestion.new
    mc_question.exam = self
    mc_question
  end

  def add_multiple_choice_question(params)
    mc_question = MultipleChoiceQuestion.new(params)
    mc_question.exam = self
    mc_question
  end

  def add_descriptive_question(params)
    question = DescriptiveQuestion.new(params)
    question.exam = self
    question
  end

  def new_descriptive_question
    question = DescriptiveQuestion.new
    question.audio_video_question = AudioVideoQuestion.new
    question.exam = self
    question
  end

  private

  def set_default_nagative_mark
    if self.negative_mark.nil?
      self.negative_mark = 0.0
    end
  end

  # def pass_criteria
  #   if pass_criteria_2.present? and !pass_criteria_2.is_a? Fixnum
  #     self.errors.add :base,  "Invalid Criteria 2"
  #   elsif pass_criteria_3.present? and !pass_criteria_3.is_a? Fixnum
  #     self.errors.add :base, "Invalid Criteria 3"
  #   elsif pass_criteria_4.present? and !pass_criteria_4.is_a? Fixnum
  #     self.errors.add :base, "Invalid Criteria 4"
  #   end
  # end

end
