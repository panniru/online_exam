class SchedulesController < ApplicationController
  load_resource :only => [:new, :edit, :show, :update]
  authorize_resource
  def index
    @schedules = Schedule.all.order("id DESC")
  end


  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      flash.now[:success] = I18n.t :success, :scope => [:schedule, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:schedule, :create]
      render "new"
    end
  end

  def update
    if @schedule.update(schedule_params)
      flash.now[:success] = I18n.t :success, :scope => [:schedule, :update]
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
      render "show"
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:course_id, :exam_id, :exam_date, :start_time)
  end

end
