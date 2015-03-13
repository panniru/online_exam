class ChangeQuestionNoInScheduleDetails < ActiveRecord::Migration
  def change
    change_column :schedule_details, :question_no, :string
  end
end
