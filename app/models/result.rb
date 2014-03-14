class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :schedule

  scope :belongs_to_student_schedule, lambda{|student_id, schedule_id| where(:student_id => student_id, :schedule_id => schedule_id)}
  scope :belongs_to_schedule, lambda{|schedule_id| where(:schedule_id => schedule_id)}
  scope :group_by_exam_result, lambda{ group(:exam_result) }
  scope :belongs_to_schedules, lambda{|schedule_ids = []| where("schedule_id IN (#{schedule_ids.join(",")})")}
  scope :filter_by_exam_result, lambda{|exam_result| where(:exam_result => exam_result)}
  scope :belongs_to_student, lambda{|student_id| where(:student_id => student_id)}
end
