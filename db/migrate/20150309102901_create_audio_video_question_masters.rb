class CreateAudioVideoQuestionMasters < ActiveRecord::Migration
  def change
    create_table :audio_video_question_masters do |t|
      t.integer :exam_id
      t.string :digi_file
      t.string :question_type, :default => "audio"
      t.string :description

      t.timestamps
    end
  end
end
