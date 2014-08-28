class ExamValidator
  include Virtus.model
  attribute :active_questions
  attribute :schedule
  attribute :exam
  attribute :user

  def initialize(schedule, current_user)
    self.schedule = schedule
    self.exam = schedule.exam
    self.user = current_user
  end
  
  def self.validate_answer(answer, answer_caught)
    answer.upcase == answer_caught.try(:upcase)
  end
  
  def validate
    right_answers = 0
    wrong_answers = 0.0
    schedule.schedule_details.belongs_to_student(user.resource.id).each do |act_qtn|
      question = act_qtn.question
      if self.class.validate_answer
        right_answers +=1
      else
        wrong_answers += exam.negative_mark
      end
    end
    marks_secured = right_answers - wrong_answers

    result = analyse_result(marks_secured)

    result = Result.new(:schedule_id => schedule.id, :total_marks => exam.no_of_questions, :marks_secured => marks_secured, :exam_result => result, :student_id => user.resource.id)
    result.save
    result
  end

  private

  def analyse_result(right_answers)
    pass_percent = (right_answers.to_f/exam.no_of_questions)*100
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
    elsif exam.pass_criteria_6.present? and pass_percent >= exam.pass_criteria_6 and pass_percent < exam.pass_criteria_5
      exam.pass_text_6
    else
      "FAIL"
    end
  end
end
