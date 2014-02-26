# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_girl_rails'

def seed_role
  role = Role.where(:code => 'admin').first_or_create!(role: "admin", description: "Super Admin")
  role = Role.where(:code => 'student').first_or_create!(role: "student", description: "Student")
  role = Role.where(:code => 'faculty').first_or_create!(role: "faculty", description: "faculty")
end

def seed_user
  role = Role.find_by_code("admin")
  stu_role = Role.find_by_code("student")
  faculty_role = Role.find_by_code("faculty")

  admin = User.where(user_id: "admin").first
  student = User.where(user_id: "student").first
  faculty = User.where(user_id: "faculty").first

  unless admin.present?
    admin =  User.new({:email => 'admin@ostryalabs.com', :password => 'welcome', :user_id => 'admin'})
    admin.role = role
    admin.save!
  end

  unless student.present?
    student =  User.new({:email => 'student@ostryalabs.com', :password => 'welcome', :user_id => 'student'})
    student.role = stu_role
    student.save!
  end

  unless faculty.present?
    faculty =  User.new({:email => 'faculty@ostryalabs.com', :password => 'welcome', :user_id => 'faculty'})
    faculty.role = faculty_role
    faculty.save!
  end

end

def seed_all
  seed_role
  seed_user
end

seed_all
