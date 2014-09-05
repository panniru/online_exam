class AddValidAnswerToScheduleDetails < ActiveRecord::Migration
  def change
    add_column :schedule_details, :valid_answer, :boolean
  end
end
