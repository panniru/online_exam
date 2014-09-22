class AddYearAndAcademicYearToStudents < ActiveRecord::Migration
  def change
    add_column :students, :year, :integer
    add_column :students, :academic_year, :string
  end
end
