class DescriptiveQuestionsController < ApplicationController
  before_action :load_exam
  before_action :load_question, :only => [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    @title = "Descriptive Questions"
    @questions = @exam.descriptive_questions.order("id DESC").paginate(:page => page)
  end

  def new
    @question = @exam.new_descriptive_question
  end

  def create
    @question = @exam.add_descriptive_question(question_params)
    if @question.save
      flash.now[:success] = I18n.t :success, :scope => [:question, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :create]
      render "multiple_choice_questions/new"
    end
  end

  def update
    if @question.update(update_params)
      flash.now[:success] = I18n.t :success, :scope => [:question, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :update]
      render "multiple_choice_questions/edit"
    end
  end

  def xls_template_descriptive
    respond_to do |format|
      @question = DescriptiveQuestion.new
      format.xls { send_data @question.xls_template(col_sep: "\t")}
    end
  end

  def edit
    render "edit"
  end

  def destroy
    if @question.destroy
      flash[:success] = I18n.t :success, :scope => [:question, :destroy]
      redirect_to exam_descriptive_questions_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :destroy]
      render "show"
    end
  end

  def upload_new
    @upload_question = DescriptiveQuestionUploader.new
    @upload_question.exam_id = params[:exam_id]
  end

  def upload
    @upload_question = DescriptiveQuestionUploader.new(params[:descriptive_question_uploader])
    if @upload_question.save
      flash[:success] = I18n.t :success, :scope => [:question, :upload]
      redirect_to exam_descriptive_questions_path(@exam)
    else
      render "upload_new"
    end
  end

  private

  def load_exam
    @exam = Exam.find(params[:exam_id])
  end

  def load_question
    @question = @exam.descriptive_questions.find(params[:id])
  end

  def question_params
    params.require(:multiple_choice_question).permit(:description, :answer, :is_descriptive)
  end

  def update_params
    params.require(:descriptive_question).permit(:description, :answer)
  end
end
