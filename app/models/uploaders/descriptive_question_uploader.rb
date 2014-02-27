class DescriptiveQuestionUploader
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
      question = DescriptiveQuestion.find_by_id(row["id"]) || DescriptiveQuestion.new
      question.attributes = row.to_hash.slice("description", "answer")
      question.exam_id = self.exam_id
      question
    end
  end

end
