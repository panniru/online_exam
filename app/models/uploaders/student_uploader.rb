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
      user = student.build_user
      user.attributes = {:email => row["email"], :user_id => student.roll_number.to_s, :password => "welcome", :password_confirmation => "welcome", :role_id => Role.student_role.id }
      student

    end
  end

  def xls_template(options)
    template_headers = ["roll_number", "name", "dob", "joining_date", "semester", "email"]
    CSV.generate(options) do |csv|
      csv << template_headers
    end
  end

end
