class ActiveQuestion
  include Virtus.model
  attribute :question_id, Integer
  attribute :answer_caught
  attribute :active_question_no, Integer
  attribute :description
  attribute :option_1
  attribute :option_2
  attribute :option_3
  attribute :option_4
  attribute :is_descriptive
  attribute :digi_file_url

  def descriptive?
    is_descriptive
  end
end
