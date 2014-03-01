class Student < ActiveRecord::Base
  validates :roll_number, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :course_id, :presence => true
  validates :semister, :presence => true

  belongs_to :course
  has_many :results

  has_one :user, :dependent => :destroy, :foreign_key => "resource_id"
  accepts_nested_attributes_for :user



  scope :search, lambda { |id| where(:id => id)}

  def course_name
    course.name
  end

end
