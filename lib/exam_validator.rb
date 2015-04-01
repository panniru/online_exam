class ExamValidator
  include Virtus.model
  attribute :active_questions
  attribute :schedule
  attribute :exam
  attribute :user

  def initialize(exam,schedule = nil, current_user=nil)
    self.schedule = schedule
    self.exam = exam
    self.user = current_user
  end
  
  def self.validate_answer(answer, answer_caught)
    answer.upcase == answer_caught.try(:upcase)
  end
  
  def validate
    right_answers = 0
    wrong_answers = 0.0
    schedule.schedule_details.belongs_to_student(user.resource.id).each do |act_qtn|
      question = act_qtn.question_for_validation
      if self.class.validate_answer(question.answer, act_qtn.answer_caught)
        act_qtn.update_attributes({:valid_answer => true})
        right_answers += question_marks(question)
      else
        act_qtn.update_attributes({:valid_answer => false})
        wrong_answers += negetive_mark_of_qtn(question)
      end
    end
    marks_secured = right_answers - wrong_answers
    result = analyse_result(marks_secured)
    result = Result.new(:schedule_id => schedule.id, :total_marks => exam.total_marks, :marks_secured => marks_secured, :exam_result => result, :student_id => user.resource.id)
    result.save
    result
  end
  

  def manipulate_student_result(result, schedule_detail_params)
    right_answer_marks = 0
    wrong_answer_marks = 0
    schedule_detail_params.each do |param|
      detail = ScheduleDetail.find(param[:id])
      detail.update_attributes({:valid_answer => param[:valid_answer]})
      if param[:valid_answer] || param[:valid_answer] == "true"
        right_answer_marks += question_marks(detail.question)
      else
        wrong_answer_marks += negetive_mark_of_qtn(detail.question)
      end
    end
    marks_secured = right_answer_marks - wrong_answer_marks
    result_text = analyse_result(marks_secured)
    result.update_attributes!({:marks_secured => marks_secured, :exam_result => result_text})
  end

  private

  def question_marks(qtn)
    if qtn.question_type == 'multiple_choice'
      exam.mark_per_mc.present? ? exam.mark_per_mc : 1
    elsif qtn.question_type == 'audio' 
      exam.mark_per_audio.present? ? exam.mark_per_audio.to_f : 1
    elsif qtn.question_type == 'video'
      exam.mark_per_video.present? ? exam.mark_per_video.to_f : 1
    else
      exam.mark_per_fib.present? ? exam.mark_per_fib : 1
    end
  end

  def negetive_mark_of_qtn(qtn)
    question_mark = question_marks(qtn)
    ((exam.negative_mark/100)*question_mark)
  end

  def analyse_result(right_answers)
    pass_percent = (right_answers.to_f/exam.total_marks)*100
    if pass_percent >= exam.pass_criteria_1
      exam.pass_text_1
    elsif exam.pass_criteria_2.present? and pass_percent >= exam.pass_criteria_2 and pass_percent < exam.pass_criteria_1
      exam.pass_text_2
    elsif exam.pass_criteria_3.present? and pass_percent >= exam.pass_criteria_3 and pass_percent < exam.pass_criteria_2
      exam.pass_text_3
    elsif exam.pass_criteria_4.present? and pass_percent >= exam.pass_criteria_4 and pass_percent < exam.pass_criteria_3
      exam.pass_text_4
    elsif exam.pass_criteria_5.present? and pass_percent >= exam.pass_criteria_5 and pass_percent < exam.pass_criteria_4
      exam.pass_text_5
    # elsif exam.pass_criteria_6.present? and pass_percent >= exam.pass_criteria_6 and pass_percent < exam.pass_criteria_5
    #   exam.pass_text_6
    else
      exam.pass_text_6
      #"FAIL"
    end
  end
end
