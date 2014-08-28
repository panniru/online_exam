class SchedulesController < ApplicationController
  load_resource :only => [:new, :edit, :show, :update, :destroy, :exam, :review_exam, :submit_exam, :exam_entrance, :validate_exam_entrance, :next_question]
  before_action :validate_exam_status, :only => [:exam, :exam_entrance, :review_exam, :next_question]

  authorize_resource

  def index
    @schedules = current_user.admin? ? Schedule.all : Schedule.role_based_schedules(current_user)
    @active_schedules = []
    @closed_schedules = []
    @schedules.each do |schedule|
      @schedule = schedule
      validate_exam_status
      if @status or session[:current_time] < formatted_start_time
        @active_schedules << schedule
      else
        @closed_schedules << schedule
      end
    end
    @active_schedules = SchedulesDecorator.decorate_collection(@active_schedules)
    @closed_schedules = SchedulesDecorator.decorate_collection(@closed_schedules)
  end


  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      flash.now[:success] = I18n.t :success, :scope => [:schedule, :create]
      @schedule = SchedulesDecorator.decorate(@schedule)
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:schedule, :create]
      render "new"
    end
  end

  def update
    if @schedule.update(schedule_params)
      flash.now[:success] = I18n.t :success, :scope => [:schedule, :update]
      @schedule = SchedulesDecorator.decorate(@schedule)
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:schedule, :update]
      render "edit"
    end
  end

  def destroy
    if @schedule.destroy
      flash[:success] = I18n.t :success, :scope => [:schedule, :destroy]
      redirect_to schedules_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:schedule, :destroy]
      @schedule = SchedulesDecorator.decorate(@schedule)
      render "show"
    end
  end

  def edit
    @schedule.exam_date = @schedule.exam_date_time.strftime("%d/%m/%Y")
    @schedule.start_time = @schedule.exam_date_time.strftime("%H:%M")
  end

  def show
    @schedule = SchedulesDecorator.decorate(@schedule)
  end

  def exam
    @exam = @schedule.exam
    @schedule = SchedulesDecorator.decorate(@schedule)

    if @status
      @question = RandomQuestionGenerator.new(@exam, @schedule.id, current_user.resource.id).session_first_question
      render "exam"
    else
      render "show"
    end
  end

  def next_question
    if @status
      @exam = @schedule.exam
      random_question_gen = RandomQuestionGenerator.new(@exam, @schedule.id, current_user.resource.id)
      @schedule = SchedulesDecorator.decorate(@schedule)
      if params[:action_for] == "prev"
        @question = random_question_gen.prev_question(params[:question_no])
      elsif params[:action_for] == "current"
        @question = random_question_gen.current_question(params[:question_no])
      else
        if params[:question_id].present?
          ScheduleDetail.make_entry(@schedule.id, params, current_user.resource.id)
        end
        @question = random_question_gen.next_question(params[:question_no])
      end
      if @question.nil? or params[:action_for] == "submit"
        redirect_to review_exam_schedule_path(@schedule)
      else
        render "exam"
      end
    else
      redirect_to submit_exam_schedule_path(@schedule)
    end
  end
  
  def exam_entrance
    @schedule = SchedulesDecorator.decorate(@schedule)
    if @status
      session[:current_user_exam_questions] = nil
      render "exam_land"
    else
      render "show"
    end
  end

  def review_exam
    @schedule = SchedulesDecorator.decorate(@schedule)
    if @status
      @schedule_details = @schedule.schedule_details.belongs_to_student(current_user.resource.id).order("question_no")
    else
      redirect_to submit_exam_schedule_path(@schedule)
    end
  end

  def submit_exam
    validator = ExamValidator.new(@schedule, current_user)
    result = validator.validate
    redirect_to @schedule
  end

  def validate_exam_entrance
    respond_to do |format|
      format.json do
        status = false
        if @schedule.access_password == params[:password]
          status = true
        end
        render :json => status
      end
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:course_id, :exam_id, :exam_date, :start_time).merge!(:schedule_date => session[:current_time])
  end

  def validate_exam_status
    @status = false
    system_time = session[:current_time]
    start_time = formatted_start_time
    end_time = formatted_end_time
    if ((start_time -  system_time)/60) <= 10.00 and system_time <= end_time and !Result.belongs_to_student_schedule(current_user.resource, @schedule).first.present? 
      @status = true
    end
    @status
  end

  def formatted_start_time
    ActiveSupport::TimeZone[current_user.time_zone.name].parse(@schedule.exam_date_time.to_s)
  end

  def formatted_end_time
    ActiveSupport::TimeZone[current_user.time_zone.name].parse(@schedule.exam_end_date_time.to_s)
  end

end
