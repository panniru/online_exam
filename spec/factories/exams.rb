# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exam do
    subject "MyString"
    semister 1
    exam "MyString"
    course_id 1
    duration 1.5
    no_of_questions 1
    negative_mark 1.5
    pass_criteria_1 1.5
    pass_text_1 "MyText"
    pass_criteria_2 1.5
    pass_text_2 "MyString"
    pass_criteria_3 1.5
    pass_text_3 "MyString"
    pass_criteria_4 1.5
    pass_text_4 "MyString"
    multiple_choice 1
    fill_in_blanks 1
  end
end
