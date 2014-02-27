class AddFacultyIdToExams < ActiveRecord::Migration
  def change
    add_column :exams, :faculty_id, :integer
  end
end
