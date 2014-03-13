class SchedulesDecorator < Draper::Decorator
  delegate_all

  def to_model
    source
  end

  def course_name
    exam.course.name
  end

  def exam_name
    exam.exam_name
  end

  def semester
    exam.semester
  end

  def duration
    "#{exam.duration} Hrs"
  end

  def formatted_exam_date_time
    exam_date_time.strftime("%d-%m-%Y %H:%M")
  end

  def end_time
    exam_end_date_time.strftime("%d-%m-%Y %H:%M")
  end

  def count_exam_date
    "#{exam_date_time.strftime("%Y/%m/%d %H:%M")}"
  end

  def count_down_exam_end_time
    "#{exam_end_date_time.strftime("%Y/%m/%d %H:%M")}"
  end

end
