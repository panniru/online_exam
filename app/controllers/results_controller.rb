class ResultsController < ApplicationController

  skip_authorization_check
  load_resource :only => [:result_in_detail, :update_result_details]
  before_action :load_exam, :only => [:exam_results]
  before_action :current_user_exams


  def index
  end

  def exam_results
    respond_to do |format|
      date_from = params[:schedule_date_from].present? ? Date.strptime(params[:schedule_date_from], "%d-%m-%Y") : nil
      date_to = params[:schedule_date_to].present? ? Date.strptime(params[:schedule_date_to], "%d-%m-%Y") : nil
      schedules = []
      if date_from.present?
        schedules = @exam.schedules.dated_on_or_after(date_from).map(&:id)
      else
        schedules = @exam.schedules.scheduled_between(date_from, date_to).map(&:id)
      end
      page = params[:page].present? ? params[:page] : 1
      unless schedules.empty?
        if params[:student].present?
          @results = Result.belongs_to_student(params[:student]).belongs_to_schedules(schedules).paginate(:page => 1)
        else
          @results = Result.belongs_to_schedules(schedules).paginate(:page => page)
        end
        format.html do
          @results = ResultsDecorator.decorate_collection(@results)
        end
        format.pdf do
          @results = ResultsDecorator.decorate_collection(@results)
          render :pdf => "#{@exam.exam_name} Results ",
          :template => 'results/results',
          :formats => [:pdf],
          :locals => { exam_name: @exam.exam_full_name, date: params[:schedule_date], results: @results },
          :page_size  => 'A4',
          :margin => {:top => '8mm',
            :bottom => '8mm',
            :left => '14mm',
            :right => '14mm'}
        end
        format.json do
          json_data = {}
          json_data[:results] = @results.map do |r|
            r = ResultsDecorator.decorate(r)
            { :id => r.id , :roll_number => r.student_roll_number, :marks_secured=> r.marks_secured, :total_marks => r.total_marks, :url => result_in_detail_result_path(r), :semester => r.semester, :exam_date => r.exam_date, :exam_result => r.exam_result, :exam_name => r.exam_name, :student_name => r.student_name }
          end
          render :json => JsonPagination.inject_pagination_entries(@results, json_data)
        end
      else
        format.json do
          render :json => {results: []}
        end
      end
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
          {:id => detail.id, :question_no => detail.question_no, :question_description => detail.question_for_validation.description_without_html, :answer => detail.question_for_validation.answer, :answer_caught => detail.answer_caught, :valid_answer => detail.valid_answer?, :question_type => detail.question_type.try(:titleize)}
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

  def mail
    respond_to do |format|
      format.json do
        @exam = Exam.find(params[:exam_id])
        tos = params[:email].split(",").map(&:strip)
        mail_job = ResultMailingJob.new(@exam, tos, params[:subject], params[:content], params[:schedule_date])
        Delayed::Job.enqueue mail_job
        render :json => {status: true}
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
