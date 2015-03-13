class AddAudioVideoQuestionsToExams < ActiveRecord::Migration
  def change
    add_column :exams, :audio_questions, :integer
    add_column :exams, :video_questions, :integer
    add_column :exams, :mark_per_audio, :float
    add_column :exams, :mark_per_video, :float
  end
end
