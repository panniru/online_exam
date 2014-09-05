class ResultsController < ApplicationController

  skip_authorization_check
  load_resource :only => [:result_in_detail, :update_result_details]
  before_action :load_exam, :only => [:exam_results]
  before_action :current_user_exams


  def exam_results
    schedules = @exam.schedules.map(&:id)
    page = params[:page].present? ? params[:page] : 1
    unless schedules.empty?
      if params[:student].present?
        @results = Result.belongs_to_student(params[:student]).belongs_to_schedules(@exam.schedules.map(&:id)).paginate(:page => 1)
      else
        @results = Result.belongs_to_schedules(@exam.schedules.map(&:id)).paginate(:page => page)
      end
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
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:report, :results]
      render "index"
    end
  end

  def result_in_detail
    respond_to do |format|
      @schedule = SchedulesDecorator.decorate(@result.schedule)
      format.html do
      end
      format.json do
        @student = @result.student
        @schedule_details = @schedule.schedule_details.belongs_to_student(@student.id).order("question_no")
        @schedule_details = ScheduleDetailsDecorator.decorate_collection(@schedule_details)
        details = @schedule.schedule_details.belongs_to_student(@student.id).order("question_no").map do |detail|
          {:id => detail.id, :question_no => detail.question_no, :question_description => detail.question.description, :answer => detail.question.answer, :answer_caught => detail.answer_caught, :valid_answer => detail.valid_answer?}
        end
        render :json => {:marks_secured => @result.marks_secured, :result_text => @result.exam_result, :details => details}
      end
    end
  end

  def update_result_details
    validator = ExamValidator.new(@result.schedule.exam)
    respond_to do |format|
      format.json do
        if validator.manipulate_student_result(@result, params[:schedule_details])
          render :json => {:marks_secured => @result.marks_secured, :result_text => @result.exam_result}
        else
          render :json => false
        end
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
