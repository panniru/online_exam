class ResultsDecorator < ApplicationDecorator

  def to_model
    source
  end

  def exam_name
    schedule.exam.exam_name
  end

  def exam_date
    schedule.exam_date_time.strftime("%d/%m/%Y")
  end

  def semester
    schedule.exam.semester
  end

  def student_name
    student.name
  end

  def student_roll_number
    student.roll_number
  end

end
