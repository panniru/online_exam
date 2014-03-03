class StudentUploader
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Uploader
  attr_accessor :course_id

  def persisted?
    false
  end

  def initialize(params = {})
    super(params[:file])
    self.course_id = params[:course_id]
  end

  def save
    super do |row|
      student = Student.find_by_id(row["id"]) || Student.new
      student.attributes = row.to_hash.slice("name", "dob", "joining_date", "semester", "roll_number")
      student.course_id = course_id
      student
    end
  end

  def xls_template(options)
    template_headers = ["roll_number", "name", "dob", "joining_date", "semester"]
    CSV.generate(options) do |csv|
      csv << template_headers
    end
  end

end
