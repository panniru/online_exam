WillPaginate.per_page = 10
class Student < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name, :roll_number]

  validates :roll_number, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :course_id, :presence => true
  validates :semester, :presence => true

  belongs_to :course
  has_many :results, :dependent => :destroy

  belongs_to :user

  accepts_nested_attributes_for :user

  scope :search, lambda { |id| where(:id => id)}
  scope :belongs_to_course, lambda { |course_id| where(:course_id => course_id)}
  scope :belongs_to_semester, lambda { |semester| where(:semester => semester)}

  def course_name
    course.try(:name)
  end

  def exams
  end

end
