class MultipleChoiceQuestionsController < ApplicationController
  before_action :load_exam
  before_action :load_question, :only => [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    @title = "Questions"
    @view = params[:view]
    @questions = @exam.multiple_choice_questions.order("id DESC").paginate(:page => page)
  end

  def new
    @question = @exam.new_multiple_choice_question
  end

  def create
    @question = @exam.add_multiple_choice_question(question_params)
    if @question.save
      flash.now[:success] = I18n.t :success, :scope => [:question, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :create]
      render "new"
    end
  end

  def update
    if @question.update(question_params)
      flash.now[:success] = I18n.t :success, :scope => [:question, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :update]
      render "edit"
    end
  end

  def upload_new
    @upload_question = MultipleChoiceQuestionUploader.new()
    @upload_question.exam_id = params[:exam_id]
  end

  def upload
    @upload_question = MultipleChoiceQuestionUploader.new(params[:multiple_choice_question_uploader])
    if @upload_question.save
      flash[:success] = I18n.t :success, :scope => [:question, :upload]
      redirect_to exam_multiple_choice_questions_path(@exam)
    else
      render "upload_new"
    end
  end

  def xls_template
    respond_to do |format|
      @question = MultipleChoiceQuestion.new
      format.xls { send_data @question.xls_template(col_sep: "\t")}
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = I18n.t :success, :scope => [:question, :destroy]
      redirect_to exam_multiple_choice_questions_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :destroy]
      render "show"
    end
  end

  private

  def load_exam
    @exam = Exam.find(params[:exam_id])
  end

  def load_question
    @question = @exam.multiple_choice_questions.find(params[:id])
  end

  def question_params
    params.require(:multiple_choice_question).permit(:description, :option_1, :option_2, :option_3, :option_4, :answer, :is_descriptive, :audio_video_question_attributes => [:digi_file])
  end

end
