class Schedule < ActiveRecord::Base
  attr_accessor :course_id, :exam_date, :start_time

  validates :exam_date, :presence => true
  validates :start_time, :presence => true

  before_save :set_exam_date_time
  belongs_to :exam

  private


  def set_exam_date_time
    self.exam_date_time = Time.zone.parse("#{exam_date} #{start_time}")
    self.exam_end_date_time = self.exam_date_time+self.exam.duration.hours
    puts "=============>#{self.exam_date_time}"
    puts "=============>#{self.exam_end_date_time}"
  end

end
