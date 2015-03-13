class ScheduleDetail < ActiveRecord::Base
  
  belongs_to :schedule
  belongs_to :student
  
  scope :belongs_to_student, lambda{|student| where(:student_id => student)}
  scope :belongs_to_schedule, lambda{|schedule| where(:schedule_id => schedule)}
  scope :belongs_to_question_type, lambda{|question_type| where(:question_type => question_type)}
  scope :belongs_to_question_id, lambda{|question_id| where(:question_id => question_id)}
  scope :check_existent_question, lambda{|student_id, schedule_id, question_type, question_id| belongs_to_student(student_id).belongs_to_schedule(schedule_id).belongs_to_question_type(question_type).belongs_to_question_id(question_id)}

  def question_for_validation
    if self.question_type == "descriptive"
      DescriptiveQuestion.find(question_id)
    else
      MultipleChoiceQuestion.find(question_id)
    end
  end

  def question
    if self.question_type == "descriptive"
      DescriptiveQuestion.find(question_id)
    elsif (question_type == "audio" or question_type == "video")
      AudioVideoQuestionMaster.find(audio_video_question_master_id)
    elsif question_type == "multiple_choice"
      MultipleChoiceQuestion.find(question_id)
    end
  end

  def self.make_entry(schedule_id, params, student_id)
    if params[:question_type] == "audio" or params[:question_type] == "video" 
      params[:children_questions].each_with_index do |question_params, index|
        question_params[:question_type] = params[:question_type]
        question_params[:audio_video_question_master_id] = params[:question_id]
        #question_params[:question_no] = params[:question_no].to_i + index
        save_schedule_detail(schedule_id, question_params, student_id)
      end
    else
      save_schedule_detail(schedule_id, params, student_id)
    end
  end

  def self.save_schedule_detail(schedule_id, params, student_id)
    matched_details = self.check_existent_question(student_id, schedule_id, params[:question_type], params[:question_id]).first
    if matched_details.present?
      matched_details.update({:answer_caught => params[:answer_caught]})
    else
      ScheduleDetail.create!(:schedule_id => schedule_id, :question_id => params[:question_id], :student_id => student_id, :question_type => params[:question_type], :answer_caught => params[:answer_caught], :question_no => params[:question_no], :audio_video_question_master_id => params[:audio_video_question_master_id]) 
    end
  end

end
