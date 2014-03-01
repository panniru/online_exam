# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exam do
    subject "Chemistry"
    semister 1
    exam_name "MID TERM1"
    course_id 1
    duration 0.30
    no_of_questions 10
    negative_mark 0.25
    pass_criteria_1 85
    pass_text_1 "Distinction"
    pass_criteria_2 75
    pass_text_2 "First Division"
    pass_criteria_3 60
    pass_text_3 "Secound Division"
    pass_criteria_4 40
    pass_text_4 "Passed"
    multiple_choice 4
    fill_in_blanks 6
  end
end
