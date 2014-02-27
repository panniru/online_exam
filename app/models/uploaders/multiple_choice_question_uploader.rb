class MultipleChoiceQuestionUploader
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Uploader
  attr_accessor :exam_id

  def persisted?
    false
  end

  def initialize(params = {})
    super(params[:file])
    self.exam_id = params[:exam_id]
  end

  def save
    super do |row|
      question = MultipleChoiceQuestion.find_by_id(row["id"]) || MultipleChoiceQuestion.new
      question.attributes = row.to_hash.slice("description", "option_1", "option_2", "option_3", "option_4", "answer")
      question.exam_id = self.exam_id
      question
    end
  end
end
