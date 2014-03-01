# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :result do
    schedule_id 1
    total_marks 1
    marks_secured 1.5
    exam_result "MyString"
    student_id 1
  end
end
