class AddTypeToMultipleChoiceQuestions < ActiveRecord::Migration
  def change
    add_column :multiple_choice_questions, :question_type, :string, :default => "multiple_choice"
    add_column :multiple_choice_questions, :audio_video_question_master_id, :integer
  end
end
