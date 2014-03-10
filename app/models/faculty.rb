class Faculty < ActiveRecord::Base

  validates :name, :presence => true
  after_save :insert_faculty_course

  belongs_to :user
  accepts_nested_attributes_for :user

  attr_accessor :department_ids
  has_many :courses, :through => :faculty_courses
  has_many :faculty_courses
  has_many :exams

  scope :search, lambda { |id| where(:id => id)}

  def selected_courses
    if self.courses.present?
      courses.map{|c| c.id }
    else
      []
    end
  end

  def course_names
    courses.map{|c| c.name}.join(", ")
  end

  private

  def insert_faculty_course
    courses = []
    if self.courses.present?
      courses = self.courses.map{ |course| course.id}
    end
    courses.each do |id|
      department_ids.delete(id.to_s)
    end
    department_ids.delete("")
    department_ids.each do |dept|
      fc = FacultyCourse.new(:faculty_id => self.id, :course_id => dept)
      unless fc.save
        self.errors.add :base, fc.errors.full_messages.first
        raise ActiveRecord::Rollback
      end
    end
  end

end
