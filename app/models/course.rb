class Course < ActiveRecord::Base
  validates :name, :presence => true

  has_many :faculties, :through => :facultycourse

  scope :search, lambda { |id| where(:id => id)}
end
