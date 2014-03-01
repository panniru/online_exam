class ResultsDecorator < Draper::Decorator
  delegate_all

  def exam_name
    schedule.exam.exam_name
  end

  def exam_date
    schedule.exam_date_time.strftime("%d/%m/%Y")
  end

  def semister
    schedule.exam.semister
  end


end
