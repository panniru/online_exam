class RandomQuestionGenerator
  include Virtus.model
  attribute :exam
  attribute :student_id
  attribute :schedule_id
  attribute :current_user

  def initialize(exam, schedule_id, student_id, current_user = nil)
    self.exam = exam
    self.schedule_id = schedule_id
    self.student_id = student_id
    self.current_user = current_user
  end

  def session_first_question
    schedule_details = get_schedule_details.last
    schedule_details.present? ? active_question(schedule_details.question, schedule_details.question_no, schedule_details.answer_caught) : new_question
  end

  def prev_question(current_question_no)
    schedule_details = detail_on_question_no(current_question_no.to_i-1)
    schedule_details.present? ? active_question(schedule_details.question, schedule_details.question_no, schedule_details.answer_caught) : nil
  end

  def next_question(current_question_no)
    schedule_details = detail_on_question_no(current_question_no.to_i+1)
    schedule_details.present? ? active_question(schedule_details.question, schedule_details.question_no, schedule_details.answer_caught) : new_question
  end

  def current_question(question_no)
    schedule_details = detail_on_question_no(question_no)
    schedule_details.present? ? active_question(schedule_details.question, schedule_details.question_no, schedule_details.answer_caught) : nil
  end

  def detail_on_question_no(number)
    ScheduleDetail.belongs_to_student(student_id).belongs_to_schedule(schedule_id).where(:question_no => number.to_s).first
  end

  def generate_all_questions_on_submit
    schedule_details = get_schedule_details
    until existed_questions_count >= exam.no_of_questions
      question = new_question
      schedule_details << question
      ScheduleDetail.make_entry(schedule_id, question, current_user.resource.id)
    end
  end
  

  def new_question
    count_exist = existed_questions_count
    return nil if  count_exist>= exam.no_of_questions
    next_question = nil
    question_type = next_question_type
    if question_type == "descriptive"
      next_question = load_descriptive_question
    elsif (question_type == "audio" or question_type == "video")
      next_question = load_audio_video_question(question_type)
    else
      next_question = load_multiple_choice_question
    end
    active_question(next_question, count_exist+1)
  end

  def next_question_type
    question_list = []
    question_list = question_list
    audio_list = (exam.audio_questions.to_i - existed_question_type_count("audio")).times.map{|i|"audio"}
    video_list = (exam.video_questions.to_i - existed_question_type_count("video")).times.map{|i| "video"}  
    discreptove_multiple = (exam.multiple_choice.to_i - existed_question_type_count("multiple_choice")).times.map{|i| "multiple_choice"} + (exam.fill_in_blanks.to_i - existed_question_type_count("descriptive")).times.map{|i| "descriptive"}   
    (question_list + audio_list + video_list + discreptove_multiple.shuffle).first
  end
  
  private

  def existed_questions_count
    ScheduleDetail.from('(SELECT question_type, audio_video_question_master_id, count(*) count FROM "schedule_details" WHERE "schedule_details"."student_id" = '+student_id.to_s+' AND "schedule_details"."schedule_id" = '+schedule_id.to_s+' group by question_type, audio_video_question_master_id) schedule_details').inject(0){|sum, rec| (rec.question_type == 'audio' or rec.question_type == 'video') ? sum +1 : sum+ rec.count }
  end

  def existed_questions
    ScheduleDetail.select(:question_id, :question_type, :audio_video_question_master_id).belongs_to_student(student_id).belongs_to_schedule(schedule_id) #@existed_questions ||= 
  end

  def exists?(id, type)
    existed_questions.select{|qtn| qtn.question_id == id and qtn.question_type == type }.count > 0
  end

  def existed_question_type_count(type)
    existed_questions.select{|qtn| qtn.question_type == type}.count
  end
  
  def get_schedule_details
    @schedule_details ||= ScheduleDetail.belongs_to_student(student_id).belongs_to_schedule(schedule_id)
  end

  def active_question(question, sequence, answer = nil)
    if question.is_a?AudioVideoQuestionMaster
      active_qtn = ActiveQuestion.new(:question_id => question.id, :question_no => sequence, :description => question.description, :question_type => question.question_type, :digi_file_url => question.digi_file_url)
      question.multiple_choice_questions.each_with_index do |qtn, index| 
        answer_caught = get_schedule_details.select{|sd| sd.question_id == qtn.id and sd.question_type = question.question_type}.first.try(:answer_caught)
        active_qtn.children_questions << build_question(qtn, "#{sequence.to_i}.#{(index+1)}", answer_caught)
      end
      active_qtn
    else
      build_question(question, sequence, answer = nil)
    end
  end

  def build_question(question, sequence, answer = nil)
    ActiveQuestion.new(:question_id => question.id, :question_no => sequence, :description => question.description, :option_1 => question.option_1, :option_2 => question.option_2, :option_3 => question.option_3, :option_4 => question.option_4, :digi_file_url => (question.audio_video_question.present? ? question.audio_video_question.try(:digi_file_url) : nil), :answer_caught => answer, :question_type => question.question_type)
  end 
  
  def load_multiple_choice_question
    next_question_id = nil
    exam.multiple_choice_questions.select(:id).map(&:id).shuffle.each do |id|
      if !exists?(id, 'multiple_choice')
        next_question_id = id
        break;
      end
    end
    MultipleChoiceQuestion.find(next_question_id)
  end

  def load_audio_video_question(question_type)
    next_question_id = nil
    exam.audio_video_question_masters.having_question_type(question_type).select(:id).map(&:id).shuffle.each do |id|
      if !exists?(id, question_type)
        next_question_id = id
        break;
      end
    end
    AudioVideoQuestionMaster.find(next_question_id)
  end

  def load_descriptive_question
    next_question_id = nil
    exam.descriptive_questions.select(:id).map(&:id).shuffle.each do |id|
      if !exists?(id, 'descriptive')
        next_question_id = id
        break;
      end
    end
    DescriptiveQuestion.find(next_question_id)
  end

  class ActiveQuestion
    include Virtus.model
    attribute :question_id, Integer
    attribute :answer_caught
    attribute :question_no
    attribute :description
    attribute :option_1
    attribute :option_2
    attribute :option_3
    attribute :option_4
    attribute :digi_file_url
    attribute :audio_video_question_master_id
    attribute :question_type
    attribute :children_questions, []
  end


end
