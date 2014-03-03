# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    name "MyString"
    dob "2014-02-25"
    joining_date "2014-02-25"
    course_id 1
    semester 1
    email "MyString"
  end
end
