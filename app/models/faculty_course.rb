class FacultyCourse < ActiveRecord::Base
  validates :course_id , :presence => true
  validates :faculty_id , :presence => true
  belongs_to :course
  belongs_to :faculty

  scope :belonging_to_faculty, lambda{|id| where(:faculty_id => id)}
end
