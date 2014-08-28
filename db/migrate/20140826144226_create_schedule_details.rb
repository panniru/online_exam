class CreateScheduleDetails < ActiveRecord::Migration
  def change
    create_table :schedule_details do |t|
      t.integer :schedule_id
      t.integer :student_id
      t.integer :question_id
      t.string :question_type
      t.string :answer_caught

      t.timestamps
    end
  end
end
