# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instruction do
    description "MyString"
    exam_id 1
    defined_by 1
  end
end
