WillPaginate.per_page = 15
class Course < ActiveRecord::Base
  include PgSearch
  validates :name, :presence => true
  has_many :faculties, :through => :facultycourse
  has_many :exams, :dependent => :destroy
  
  multisearchable :against => [:name]

  scope :search, lambda { |id| where(:id => id)}


  def self.current_academic_year
    "#{Date.today.year}-#{(Date.today.year+1).to_s[2..3]}"
  end
  
end
