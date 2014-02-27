class DescriptiveQuestionsController < ApplicationController
  before_action :load_course
  before_action :load_question, :only => [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    @title = "Descriptive Questions"
    @questions = @course.descriptive_questions.order("id DESC").paginate(:page => page)
  end

  def new
    @question = @course.new_descriptive_question
  end

  def create
    @question = @course.add_descriptive_question(question_params)
    if @question.save
      flash.now[:success] = I18n.t :success, :scope => [:question, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :create]
      render "questions/new"
    end
  end

  def update
    if @question.update(question_params)
      flash.now[:success] = I18n.t :success, :scope => [:question, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :update]
      render "questions/edit"
    end
  end

  def xls_template_descriptive
    respond_to do |format|
      @question = DescriptiveQuestion.new
      format.xls { send_data @question.xls_template(col_sep: "\t")}
    end
  end

  def edit
    render "questions/edit"
  end

  def destroy
    if @question.destroy
      flash[:success] = I18n.t :success, :scope => [:question, :destroy]
      redirect_to course_descriptive_questions_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :destroy]
      render "show"
    end
  end


  private

  def load_course
    @course = Course.find(params[:course_id])
  end

  def load_question
    @question = @course.descriptive_questions.find(params[:id])
  end

  def question_params
      params.require(:question).permit(:description, :answer, :is_descriptive)
  end
end
