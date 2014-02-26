class Role < ActiveRecord::Base
  validates :role, :presence => true, :uniqueness => true
  has_many :users
  before_save :generate_role_code, :generate_description

  private
  def generate_role_code
    self.code = self.role.downcase.parameterize("_")
  end

  def generate_description
    self.description = self.role if self.description.blank?
  end
end
