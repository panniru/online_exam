class RenameTypeRoFileTypeAudioVideoQuestion < ActiveRecord::Migration
  def change
    rename_column :audio_video_questions, :type, :file_type
  end
end
