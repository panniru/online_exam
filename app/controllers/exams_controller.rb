class ExamsController < ApplicationController
  load_resource :only => [:show, :update, :destroy, :edit, :new]
  authorize_resource


  def new
    @exam.faculty_id = current_user.resource.id
  end

  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:search].present?
      @exams = Exam.search_by_name(params[:search]).paginate(:page => 1)
    else
      @exams = Exam.belongs_to_faculty(current_user.resource.id).order("exam_name").paginate(:page => page)
    end
  end

  def create
    @exam = Exam.create(exam_params)
    if @exam.errors.present?
      flash.now[:fail] = I18n.t :fail, :scope => [:exam, :create]
      render "new"
    else
      flash.now[:success] = I18n.t :success, :scope => [:exam, :create]
      render "show"
    end
  end

  def update
    if @exam.update(exam_params)
      flash.now[:success] = I18n.t :success, :scope => [:exam, :update]
      render "show"
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
        data = Exam.belongs_to_course(params[:course_id]).belongs_to_faculty(current_user.resource.id).map do |exam|
          ["#{exam.exam_name}, #{exam.semester}, #{exam.subject}", exam.id]
        end
        render :json => data
      end
    end
  end

  private

  def exam_params
    params.require(:exam).permit(:subject, :semester, :exam_name, :course_id, :duration, :no_of_questions, :pass_criteria_1, :pass_text_1, :pass_criteria_2, :pass_text_2, :pass_criteria_3, :pass_text_3, :pass_criteria_4, :pass_text_4, :negative_mark, :fill_in_blanks, :multiple_choice, :faculty_id)
  end

end
