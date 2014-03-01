class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :schedule_id
      t.integer :total_marks
      t.float :marks_secured
      t.string :exam_result
      t.integer :student_id

      t.timestamps
    end
  end
end
