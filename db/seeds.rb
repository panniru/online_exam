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

def seed_course
  Course.first_or_create!(name: "BSC(Chemistry)")
end

def seed_faculty_details
  course = Course.first
  Faculty.first_or_create!(name: "faculty", designation: "proffessor", department_ids: [course.id])
end

def seed_exam
  exam = Exam.first
  unless exam.present?
    exam = FactoryGirl.build(:exam)
    exam.course = Course.first
    exam.faculty_id = Faculty.first.id
    exam.save!
  end
end

def seed_questions
  exam = Exam.first
  unless MultipleChoiceQuestion.first.present?
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Who was known as Iron man of India?", option_1: "Govind Ballabh Pant", option_2: "Jawaharlal Nehru", option_3: "Subhash Chandra Bose", option_4: "Sardar Vallabhbhai Patel", answer: "Sardar Vallabhbhai Patel")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Jude Felix is a famous Indian player in which of the fields?", option_1: "Volleyball", option_2: "Tennis", option_3: "Football", option_4: "Hockey", answer: "Hockey")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Who invented the BALLPOINT PEN?", option_1: "Biro Brothers", option_2: "Waterman Brothers", option_3: "Bicc Brothers", option_4: "Write Brothers", answer: "Biro Brothers")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Which scientist discovered the radioactive element radium?", option_1: "Isaac Newton", option_2: "Albert Einstein", option_3: "Benjamin Franklin", option_4: "Marie Curie", answer: "Marie Curie")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "What Galileo invented?", option_1: "Barometer", option_2: "Pendulum clock", option_3: "Microscope", option_4: "Thermometer", answer: "Thermometer")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "This statesman, politican, scholar, inventor, and one of early presidents of USA invented the swivel chair, the spherical sundial, the moldboard plow, and the cipher wheel.", option_1: "George Washington", option_2: "Alexander Hamilton", option_3: "John Adams", option_4: "Thomas Jefferson", answer: "Thomas Jefferson")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The Battle of Plassey was fought in", option_1: "1757.0", option_2: "1782.0", option_3: "1748.0", option_4: "1764.0", answer: "1757.0")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The members of the Rajya Sabha are elected by", option_1: "the people", option_2: "Lok Sabha", option_3: "elected members of the legislative assembly", option_4: "elected members of the legislative council", answer: "elected members of the legislative assembly")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The present Lok Sabha is the", option_1: "13th Lok Sabha", option_2: "14th Lok Sabha", option_3: "15th Lok Sabha", option_4: "16th Lok Sabha", answer: "15th Lok Sabha")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The famous Dilwara Temples are situated in", option_1: "Uttar Pradesh", option_2: "Rajasthan", option_3: "Maharashtra", option_4: "Madhya Pradesh", answer: "Rajasthan")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The words 'Satyameva Jayate' inscribed below the ba...", option_1: "Rigveda", option_2: "Satpath Brahmana", option_3: "Mundak Upanishad", option_4: "Ramayana", answer: "Mundak Upanishad")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Which was the 1st non Test playing country to beat India in an international match?", option_1: " Canada", option_2: "Zimbabwe", option_3: "Sri Lanka", option_4: "East Africa", answer: "Sri Lanka")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "The nucleus of an atom consists of", option_1: "electrons and neutrons", option_2: "electrons and protons", option_3: "protons and neutrons", option_4: "  All of the above", answer: "protons and neutrons")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "'OS' computer abbreviation usually means ?", option_1: "Order of Significance", option_2: "Open Software", option_3: "Operating System", option_4: "Optical Sensor", answer: "Operating System")
    MultipleChoiceQuestion.create(exam_id: exam.id, description: "Look at this series: 2, 1, (1/2), (1/4), ... What n...", option_1: "(1/3)", option_2: "(1/8)", option_3: "(2/8)", option_4: "(1/16)", answer: "(1/8)")
  end
  unless DescriptiveQuestion.first.present?
    DescriptiveQuestion.create(exam_id: exam.id, description:"Next Number 2,3,5,7....?", answer: "11")
    DescriptiveQuestion.create(exam_id: exam.id, description:"4,8,16,32....?", answer: "64")
    DescriptiveQuestion.create(exam_id: exam.id, description:"FAG, GAF, HAI, IAH, ____", answer: "JAK")
    DescriptiveQuestion.create(exam_id: exam.id, description:"From a group of 7 men and 6 women, five persons are to be selected to form a committee so that at least 3 men are there on the committee. In how many ways can it be done?", answer: "756")
    DescriptiveQuestion.create(exam_id: exam.id, description:"SCD, TEF, UGH, ____, WKL", answer: "VIJ")
    DescriptiveQuestion.create(exam_id: exam.id, description:"Look at this series: 53, 53, 40, 40, 27, 27, ... What number should come next?", answer: "14")
  end

end

def seed_user_details
  Student.first_or_create!(name: "student", dob: "17/06/1989", joining_date: "06/06/2009", course_id: Course.first.id, semester: 1, roll_number: "088072010")
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
    student =  User.new({:email => 'student@ostryalabs.com', :password => 'welcome', :user_id => 'student', :resource_id => Student.first.id})
    student.role = stu_role
    student.save!
  end

  unless faculty.present?
    faculty =  User.new({:email => 'faculty@ostryalabs.com', :password => 'welcome', :user_id => 'faculty', :resource_id => Faculty.first.id})
    faculty.role = faculty_role
    faculty.save!
  end
end

def seed_all
  seed_course
  seed_faculty_details
  seed_exam
  seed_questions
  seed_user_details
  seed_role
  seed_user
end

seed_all
