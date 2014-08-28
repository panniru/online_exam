class AddQuestionNoToScheduleDetails < ActiveRecord::Migration
  def change
    add_column :schedule_details, :question_no, :integer
  end
end
