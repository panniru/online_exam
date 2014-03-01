class Schedule < ActiveRecord::Base
  attr_accessor :course_id, :exam_date, :start_time

  validates :exam_date, :presence => true
  validates :start_time, :presence => true

  before_save :set_exam_date_time
  before_save :start_time_format
  before_save :generate_access_password
  belongs_to :exam
  has_many :results

  scope :belongs_to_faculty, lambda { |id| where('exam_id IN (SELECT DISTINCT id FROM exams where exams.faculty_id = ?)', id )}

  scope :belongs_to_student, lambda{|course_id, semister| where('exam_id IN (SELECT DISTINCT id FROM exams where exams.course_id = ? and semister = ? )', course_id, semister)}

  def self.role_based_schedules(user)
    if user.faculty?
      Schedule.belongs_to_faculty(user.resource_id)
    elsif user.student?
      resource = user.resource
      Schedule.belongs_to_student(resource.course_id, resource.semister)
    end
  end


  private

  def start_time_format
    unless (start_time =~ /\b[0-9]{1,2}\b:\b[0-9]{1,2}\b/) == 0
      self.errors.add :base, "Invalid Start Time"
    end
  end

  def set_exam_date_time
    start_times = start_time.split(":")
    date = Date.parse(exam_date)
    self.exam_date_time = DateTime.new(date.year, date.month, date.day, start_times[0].to_i, start_times[1].to_i)
    self.exam_end_date_time = self.exam_date_time+self.exam.duration.hours
  end

  def generate_access_password
    range = [(0..9), ('A'..'Z')].map { |i| i.to_a }.flatten
    self.access_password = (0...8).map { range[rand(range.length)] }.join
  end


end
