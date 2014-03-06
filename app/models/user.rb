class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
  :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:user_id]

  validates :user_id, :presence => true, :uniqueness => true
  validates :role_id, :presence => true
  attr_accessor :time_zone

  belongs_to :role

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
    else
    end
  end

end
