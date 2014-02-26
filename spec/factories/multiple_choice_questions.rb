# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :multiple_choice_question do
    course_id 1
    description "MyString"
    option_1 "MyString"
    option_2 "MyString"
    option_3 "MyString"
    option_4 "MyString"
    answer "MyString"
  end
end
