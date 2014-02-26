class RenameExamToExamNameExams < ActiveRecord::Migration
  def change
    rename_column :exams, :exam, :exam_name
  end
end
