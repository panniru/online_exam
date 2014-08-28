class ScheduleDetailsDecorator < ApplicationDecorator

  def question_description
    question.description
  end

  def answer
    question.answer
  end

  def right_answer?
    ExamValidator.validate_answer(answer, answer_caught)
  end


end
