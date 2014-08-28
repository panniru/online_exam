class RandomQuestionGenerator
  include Virtus.model
  attribute :exam
  attribute :student_id
  attribute :schedule_id

  def initialize(exam, schedule_id, student_id)
    self.exam = exam
    self.schedule_id = schedule_id
    self.student_id = student_id
  end

  def session_first_question
    schedule_details = ScheduleDetail.belongs_to_student(student_id).belongs_to_schedule(schedule_id).last
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
    ScheduleDetail.belongs_to_student(student_id).belongs_to_schedule(schedule_id).where(:question_no => number).first
  end



  def new_question
    return nil if existed_questions.count >= exam.no_of_questions
    next_question = nil
    if next_question_type == "descriptive"
      next_question_id = nil
      exam.descriptive_questions.select(:id).map(&:id).shuffle.each do |id|
        if !exists?(id, 'descriptive')
          next_question_id = id
          break;
        end
      end
      next_question = load_descriptive_question(next_question_id)
    else
      next_question_id = nil
      exam.multiple_choice_questions.select(:id).map(&:id).shuffle.each do |id|
        if !exists?(id, 'multiple_choice')
          next_question_id = id
          break;
        end
      end
      next_question = load_multiple_choice_question(next_question_id)
    end
    active_question(next_question, existed_questions.count+1)
  end

  def next_question_type
    question_list = []
    (exam.multiple_choice - existed_question_type_count("multiple_choice")).times{ question_list << "multiple_choice"} 
    (exam.fill_in_blanks - existed_question_type_count("descriptive")).times{ question_list << "descriptive"} 
    question_list.shuffle.first
  end
  
  private

  def existed_questions
    @existed_questions ||= ScheduleDetail.select(:question_id, :question_type).belongs_to_student(student_id).belongs_to_schedule(schedule_id)
  end

  def exists?(id, type)
    existed_questions.select{|qtn| qtn.question_id == id and qtn.question_type == type }.count > 0
  end

  def existed_question_type_count(type)
    existed_questions.select{|qtn| qtn.question_type == type}.count
  end
  
  def active_question(question, sequence, answer = nil)
    active_question = ActiveQuestion.new(:question_id => question.id, :question_no => sequence, :description => question.description, :option_1 => question.option_1, :option_2 => question.option_2, :option_3 => question.option_3, :option_4 => question.option_4, :is_descriptive => ((question.is_a?DescriptiveQuestion) ? true : false), :digi_file_url => (question.audio_video_question.present? ? question.audio_video_question.try(:digi_file_url) : nil), :answer_caught => answer)
  end
  
  def load_multiple_choice_question(random_no)
    MultipleChoiceQuestion.find(random_no)
  end

  def load_descriptive_question(random_no)
    DescriptiveQuestion.find(random_no)
  end

  class ActiveQuestion
    include Virtus.model
    attribute :question_id, Integer
    attribute :answer_caught
    attribute :question_no, Integer
    attribute :description
    attribute :option_1
    attribute :option_2
    attribute :option_3
    attribute :option_4
    attribute :is_descriptive
    attribute :digi_file_url
    
    def descriptive?
      is_descriptive
    end
  end


end
