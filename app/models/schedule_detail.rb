class ScheduleDetail < ActiveRecord::Base
  
  belongs_to :schedule
  belongs_to :student
  
  scope :belongs_to_student, lambda{|student| where(:student_id => student)}
  scope :belongs_to_schedule, lambda{|schedule| where(:schedule_id => schedule)}
  scope :belongs_to_question_type, lambda{|question_type| where(:question_type => question_type)}
  scope :belongs_to_question_id, lambda{|question_id| where(:question_id => question_id)}
  scope :check_existent_question, lambda{|student_id, schedule_id, question_type, question_id| belongs_to_student(student_id).belongs_to_schedule(schedule_id).belongs_to_question_type(question_type).belongs_to_question_id(question_id)}
  scope :having_audio_video_question_master_id, lambda{|question_id| where(:audio_video_question_master_id => question_id)}

  def question_for_validation
    if self.question_type == "descriptive"
      DescriptiveQuestion.find(question_id)
    else
      MultipleChoiceQuestion.find(question_id)
    end
  end



  def question_no
    if (question_type == 'audio' or question_type == 'video')
      children_question_no = nil
      ScheduleDetail.belongs_to_question_type(question_type).belongs_to_student(student).belongs_to_schedule(schedule).order("id").each_with_index do |qtn, index| 
        if qtn.id == self.id
          children_question_no= "#{self.attributes['question_no']}.#{index+1}" 
          break;
        end
      end
      return children_question_no
    else
      self.attributes["question_no"]
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
      4.times.each_with_index do |index|
        question_params = params[:children_questions].class == Array ? params[:children_questions][index] : params[:children_questions][index.to_s] 
        question_params[:question_type] = params[:question_type]
        question_params[:audio_video_question_master_id] = params[:question_id]
        question_params[:question_no] = params[:question_no]
        question_params[:student_file_view_count] = params[:student_file_view_count]
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
      matched_details.update({:student_file_view_count => params[:student_file_view_count]})
    else
      ScheduleDetail.create!(:schedule_id => schedule_id, :question_id => params[:question_id], :student_id => student_id, :question_type => params[:question_type], :answer_caught => params[:answer_caught], :question_no => params[:question_no], :audio_video_question_master_id => params[:audio_video_question_master_id], :student_file_view_count => params[:student_file_view_count]) 
    end
  end

end
