class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable, :timeoutable,
  :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:user_id]
  include PgSearch

  validates :user_id, :presence => true, :uniqueness => true
  validates :role_id, :presence => true
  attr_accessor :time_zone

  multisearchable :against => [:user_id, :email]



  belongs_to :role

  scope :admins, lambda{ where(:role_id => Role.find_by_role("admin"))}

  has_one :student
  has_one :faculty

  def self.search(id)
    self.where(:id => id)
  end

  def admin?
    self.role.role == 'admin'
  end

  def faculty?
    self.role.role == 'faculty'
  end

  def student?
    self.role.role == 'student'
  end

  def resource
    if student?
      student
    elsif faculty?
      faculty
    end
  end

  def exams
    resource.exams
  end

end
