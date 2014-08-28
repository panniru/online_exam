class ReportsController < ApplicationController
  skip_authorization_check
  before_action :load_exam, :only => [:exam_results, :drill_result, :print, :grouped_results]
  before_action :current_user_exams

  def grouped_results
    schedules = @exam.schedules.map(&:id)
    unless schedules.empty?
      @results = Result.group_by_exam_result.belongs_to_schedules(schedules).count
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:report, :results]
      render "index"
    end
  end

  def drill_result
    @results = Result.belongs_to_schedules(@exam.schedules.map(&:id)).filter_by_exam_result(params[:filter]).order("marks_secured")
    @bar_chart_data = Hash[@results.map{|result| [result.student.roll_number, result.marks_secured]}]
    @results = ResultsDecorator.decorate_collection(@results)
  end

  def print
    @results = Result.belongs_to_schedules(@exam.schedules.map(&:id))
    @results = ResultsDecorator.decorate_collection(@results)
    respond_to do |format|
      format.pdf do
        render :pdf => "#{@exam.exam_name} Results ",
        :template => 'reports/results',
        :formats => [:pdf],
        :page_size  => 'A4',
        :margin => {:top => '8mm',
          :bottom => '8mm',
          :left => '14mm',
          :right => '14mm'}
      end
    end
  end

  private

  def load_exam
    @exam = Exam.find(params[:exam_id])
  end

  def current_user_exams
    @user_exams = current_user.admin? ? Exam.all : current_user.exams
  end

end
