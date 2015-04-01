class AddStudentFileViewCountToScheduleDetails < ActiveRecord::Migration
  def change
    add_column :schedule_details, :student_file_view_count, :integer
  end
end
