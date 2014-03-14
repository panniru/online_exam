class CreateAudioVideoQuestions < ActiveRecord::Migration
  def change
    create_table :audio_video_questions do |t|
      t.integer :exam_id
      t.string :digi_file
      t.string :answer
      t.string :type

      t.timestamps
    end
  end
end
