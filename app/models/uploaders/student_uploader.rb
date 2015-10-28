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
      student.attributes = row.to_hash.slice("name", "year", "semester", "roll_number")
      if row["course"].present?
        student.course_id = Course.where("lower(name) = ?", row["course"].downcase.strip).first.try(:id)
      else
        student.course_id = course_id
      end
      student.academic_year = Course.current_academic_year
      user = student.build_user
      user.attributes = {:email => row["email"], :user_id => student.roll_number.to_s, :password => "welcome", :password_confirmation => "welcome", :role_id => Role.student_role.id }
      student.roll_number = student.roll_number.to_i.to_s
      student
    end
  end

  def xls_template
    template_headers = ["roll_number", "name", "year", "semester", "email"]
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "Students"
    sheet1.insert_row(0,template_headers)
    book
  end

end
