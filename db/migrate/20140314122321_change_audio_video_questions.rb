class ChangeAudioVideoQuestions < ActiveRecord::Migration
  def change
    rename_column :audio_video_questions, :exam_id, :question_id
    remove_column :audio_video_questions, :answer, :string
  end
end
