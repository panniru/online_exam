class ResultsController < ApplicationController

  skip_authorization_check
  before_action :load_exam, :only => [:exam_results]
  before_action :current_user_exams


  def exam_results
    page = params[:page].present? ? params[:page] : 1
    @results = Result.belongs_to_schedules(@exam.schedules.map(&:id)).paginate(:page => page)
    @results = ResultsDecorator.decorate_collection(@results)
    respond_to do |format|
      format.html { }
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
    @user_exams = current_user.exams
  end

end
