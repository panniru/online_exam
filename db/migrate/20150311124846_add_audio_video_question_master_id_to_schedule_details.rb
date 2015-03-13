class AddAudioVideoQuestionMasterIdToScheduleDetails < ActiveRecord::Migration
  def change
    add_column :schedule_details, :audio_video_question_master_id, :integer
  end
end
