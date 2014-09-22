WillPaginate.per_page = 30
class Student < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name, :roll_number]

  validates :roll_number, :presence => true, :uniqueness => true
  validates :name, :presence => true #, format: { :with => /\A[a-z\sA-Z]+\z/, :message => "Only letters allowed" }
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

  def update_student(student_update_params)
    if student_update_params[:user_attributes][:new_password].present? and student_update_params[:user_attributes][:new_password_confirmation].present? 
      student_update_params[:user_attributes][:password] = student_update_params[:user_attributes][:new_password]
      student_update_params[:user_attributes][:password_confirmation] = student_update_params[:user_attributes][:new_password_confirmation]
    end
    self.update(student_update_params)
  end

  def self.pramote(students = [], current_semester)
    if current_semester.to_i == 2 or current_semester.to_i == 4
      self.where(:id => students).update_all("semester=#{current_semester.to_i+1}, year = year+1")
    else
      self.where(:id => students).update_all("semester=#{current_semester.to_i}+1")
    end 
  end

  def self.demote(students = [], current_semester)
    if current_semester.to_i == 3 or current_semester.to_i == 5
      self.where(:id => students).update_all("semester=#{current_semester.to_i-1}, year = year-1")
    else
      self.where(:id => students).update_all("semester=#{current_semester.to_i}-1")
    end 
  end

  def self.pramote_semester(course_id, current_semester)
    if current_semester.to_i == 2 or current_semester.to_i == 4
      self.belongs_to_course(course_id).belongs_to_semester(current_semester).update_all("semester=#{current_semester.to_i+1}, year = year+1")
    else
      self.belongs_to_course(course_id).belongs_to_semester(current_semester).update_all("semester=#{current_semester.to_i}+1")
    end 
  end

  def self.demote_semester(course_id, current_semester)
    if current_semester.to_i == 3 or current_semester.to_i == 5
      self.belongs_to_course(course_id).belongs_to_semester(current_semester).update_all("semester=#{current_semester.to_i-1}, year = year-1")
    else
      self.belongs_to_course(course_id).belongs_to_semester(current_semester).update_all("semester=#{current_semester.to_i}-1")
    end 
  end

end
