class Instruction < ActiveRecord::Base
  belongs_to :user, :foreign_key => :defined_by
  belongs_to :exam
  scope :belongs_to_all, where(:exam_id => nil)
  scope :belongs_to_exam, lambda{|exam_id| where(:exam_id => exam_id)}
  scope :belongs_to_all_and_exam, lambda{|exam_id| where("exam_id IS NULL OR exam_id = ?", exam_id) }
end
