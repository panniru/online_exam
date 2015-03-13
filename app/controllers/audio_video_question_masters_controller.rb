class AudioVideoQuestionMastersController < ApplicationController
  before_action :load_exam
  before_action :load_audio_video_question_master, :only => [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    @title = "Audio Video Questions"
    @view = params[:view]
    @audio_video_question_masters = @exam.audio_video_question_masters.having_question_type(params[:question_type]).order("id DESC").paginate(:page => page, :per_page => 5)
  end

  def new
    @audio_video_question_master = @exam.new_audio_video_question_master(params[:question_type])
  end

  def create
    @audio_video_question_master = AudioVideoQuestionMaster.preapre_a_v_question(params)
    if @audio_video_question_master.save_question
      flash.now[:success] = I18n.t :success, :scope => [:question, :create]
      redirect_to exam_audio_video_question_master_path(@exam, @audio_video_question_master)
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :create]
      render "new"
    end
  end

  def edit
  end

  def update
    if @audio_video_question_master.update_a_v_question(params)
      flash.now[:success] = I18n.t :success, :scope => [:question, :update]
      redirect_to exam_audio_video_question_master_path(@exam, @audio_video_question_master)
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :update]
      render "edit"
    end
  end

  def destroy
    if @audio_video_question_master.destroy
      flash[:success] = I18n.t :success, :scope => [:question, :destroy]
      redirect_to exam_audio_video_question_masters_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:question, :destroy]
      render "show"
    end
  end

  private

  def load_exam
    @exam = Exam.find(params[:exam_id])
  end

  def load_audio_video_question_master
    @audio_video_question_master = @exam.audio_video_question_masters.find(params[:id])
  end


end
