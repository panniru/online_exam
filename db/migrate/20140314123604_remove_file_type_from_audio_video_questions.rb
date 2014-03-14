class RemoveFileTypeFromAudioVideoQuestions < ActiveRecord::Migration
  def change
    remove_column :audio_video_questions, :file_type, :string
  end
end
