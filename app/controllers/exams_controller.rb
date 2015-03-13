class ExamsController < ApplicationController
  load_resource :only => [:show, :update, :destroy, :edit, :new, :schedules]
  authorize_resource


  def new
    @exam.faculty_id = current_user.admin? ? nil : current_user.resource.id
  end

  def index
    respond_to do |format|
      format.html do
        page = params[:page].present? ? params[:page] : 1
        if params[:search].present?
          @exams = Exam.search_by_name(params[:search]).paginate(:page => 1)
        else
          @exams = current_user.exams.order("exam_name").paginate(:page => page)
        end
      end
      format.json do
        exams = current_user.exams.order("exam_name").map do |exam|
          exam.attributes.merge(:exam_full_name => exam.exam_full_name)
        end
        render :json => exams
      end
    end
  end

  def create
    @exam = Exam.create(exam_params)
    if @exam.errors.present?
      flash.now[:fail] = I18n.t :fail, :scope => [:exam, :create]
      render "new"
    else
      flash.now[:success] = I18n.t :success, :scope => [:exam, :create]
      redirect_to @exam
    end
  end

  def update
    if @exam.update(exam_params)
      flash.now[:success] = I18n.t :success, :scope => [:exam, :update]
      redirect_to @exam
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:exam, :update]
      render "edit"
    end
  end

  def destroy
    if @exam.destroy
      flash.now[:success] = I18n.t :success, :scope => [:exam, :destroy]
      redirect_to exams_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:exam, :destroy]
    end
  end

  def course_exams_json
    respond_to do |format|
      format.json do
        data = [""]
        data = Exam.belongs_to_course(params[:course_id])
        data = current_user.admin? ? data : data.belongs_to_faculty(current_user.resource.id)
        data = data.map do |exam|
          ["#{exam.exam_name}, #{exam.semester}, #{exam.subject}", exam.id]
        end
        render :json => data
      end
    end
  end

  def schedules
    respond_to do |format|
      format.json do
        render :json => @exam.schedules.select(:schedule_date).uniq
      end
    end
  end

  private

  def exam_params
    params.require(:exam).permit(:subject, :semester, :exam_name, :course_id, :duration, :no_of_questions, :pass_criteria_1, :pass_text_1, :pass_criteria_2, :pass_text_2, :pass_criteria_3, :pass_text_3, :pass_criteria_4, :pass_text_4, :pass_criteria_5, :pass_text_5, :pass_criteria_6, :pass_text_6, :negative_mark, :fill_in_blanks, :multiple_choice, :faculty_id, :mark_per_fib, :mark_per_mc, :video_questions, :audio_questions, :mark_per_video, :mark_per_audio) #:pass_criteria_6
  end

end
