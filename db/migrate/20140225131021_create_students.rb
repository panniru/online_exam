class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.date :dob
      t.date :joining_date
      t.integer :course_id
      t.integer :semister
      t.string :email

      t.timestamps
    end
  end
end
