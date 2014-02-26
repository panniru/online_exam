class FacultyCourse < ActiveRecord::Base
  validates :course_id , :presence => true
  validates :faculty_id , :presence => true
  belongs_to :course
  belongs_to :faculty
end
