class RemoveDobAndJoningDateFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :dob, :date
    remove_column :students, :joining_date, :date
  end
end
