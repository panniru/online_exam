# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    exam_id 1
    exam_date_time ""
    exam_end_date_time ""
    schedule_date "2014-02-27"
    access_password "MyString"
    schedule_id "MyString"
  end
end
