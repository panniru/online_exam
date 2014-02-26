class CoursesController < ApplicationController
load_resource :only => [:show, :update, :edit, :destroy, :new]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:search].present?
      @courses = Course.search(params[:search]).paginate(:page => 1)
    else
      @courses = Course.all.order("name").paginate(:page => page)
    end
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash.now[:success] = I18n.t :success, :scope => [:course, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:course, :create]
      render "new"
    end
  end

  def update
    if @course.update(course_params)
      flash.now[:success] = I18n.t :success, :scope => [:course, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:course, :update]
      render "edit"
    end
  end

  def destroy
    if @course.destroy
      flash.now[:success] = I18n.t :success, :scope => [:course, :destroy]
      redirect_to courses_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:course, :destroy]
      render "show"
    end
  end

  private

  def course_params
    params.require(:course).permit(:name)
  end
end
