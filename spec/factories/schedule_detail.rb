# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule_detail, :class => 'ScheduleDetails' do
    schedule_id 1
    student_id 1
    question_id 1
    question_type "MyString"
    answer_caught "MyString"
  end
end
