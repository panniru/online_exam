WillPaginate.per_page = 15
class Course < ActiveRecord::Base
  include PgSearch
  validates :name, :presence => true
  has_many :faculties, :through => :facultycourse

  multisearchable :against => [:name]

  scope :search, lambda { |id| where(:id => id)}


end
