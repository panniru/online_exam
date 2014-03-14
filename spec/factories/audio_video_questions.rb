# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audio_video_question do
    exam_id 1
    digi_file "MyString"
    answer "MyString"
    type ""
  end
end
