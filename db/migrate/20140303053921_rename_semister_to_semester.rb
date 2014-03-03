class RenameSemisterToSemester < ActiveRecord::Migration
  def change
    rename_column :exams, :semister, :semester
    rename_column :students, :semister, :semester
  end
end
