class Schedule < ActiveRecord::Base
  attr_accessor :course_id, :exam_date, :start_time

  validates :exam_date, :presence => true
  validates :start_time, :presence => true
  validate :start_time_format
  validate :validate_exam_questions
  
  before_save :set_exam_date_time
  before_save :start_time_format
  before_save :generate_access_password
  
  belongs_to :exam
  has_many :results, :dependent => :destroy
  has_many :schedule_details, :dependent => :destroy

  scope :belongs_to_faculty, lambda { |id| where('exam_id IN (SELECT DISTINCT id FROM exams where exams.faculty_id = ?)', id )}

  scope :belongs_to_student, lambda{|course_id, semester| where('exam_id IN (SELECT DISTINCT id FROM exams where exams.course_id = ? and semester = ? )', course_id, semester)}
  scope :dated_on, lambda{|date| where(:schedule_date => date)}
  scope :scheduled_between, lambda{|from_date, to_date| where(:schedule_date => (from_date..to_date))}
  scope :dated_on_or_after, lambda{|from_date| where("schedule_date >= ?", from_date)}

  def self.role_based_schedules(user)
    if user.faculty?
      Schedule.belongs_to_faculty(user.resource.id)
    elsif user.student?
      resource = user.resource
      Schedule.belongs_to_student(resource.course_id, resource.semester)
    end
  end


  private
  
  def validate_exam_questions
    unless (self.exam.multiple_choice_questions.count >= self.exam.multiple_choice and self.exam.descriptive_questions.count >= self.exam.fill_in_blanks and self.exam.audio_video_question_masters.having_question_type("audio").count >= self.exam.audio_questions and self.exam.audio_video_question_masters.having_question_type("video").count >= self.exam.video_questions)
      self.errors.add :base, "Exam Has not enough questions to schedule as per inputs"
    end
  end
  
  def start_time_format
    unless (start_time =~ /\b[0-9]{1,2}\b:\b[0-9]{1,2}\b/) == 0
      self.errors.add :base, "Invalid Start Time"
    end
  end

  def set_exam_date_time
    start_times = start_time.split(":")
    date = Date.parse(exam_date)
    self.exam_date_time = DateTime.new(date.year, date.month, date.day, start_times[0].to_i, start_times[1].to_i)
    self.exam_end_date_time = self.exam_date_time+(self.exam.duration.to_f/60).hours #make duration in mins to seconds
  end

  def generate_access_password
    range = [(0..9), ('A'..'Z')].map { |i| i.to_a }.flatten
    self.access_password = (0...8).map { range[rand(range.length)] }.join
  end


end
