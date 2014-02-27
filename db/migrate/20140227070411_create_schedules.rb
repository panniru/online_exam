class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :exam_id
      t.datetime :exam_date_time
      t.datetime :exam_end_date_time
      t.date :schedule_date
      t.string :access_password
      t.string :schedule_id

      t.timestamps
    end
  end
end
