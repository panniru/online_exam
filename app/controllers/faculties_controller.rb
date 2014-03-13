class FacultiesController < ApplicationController
  load_resource :only => [:show, :update, :edit, :destroy, :new]
  authorize_resource

  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:search].present?
      @faculties = Faculty.search(params[:search]).paginate(:page => 1)
    else
      @faculties = Faculty.all.order("name").paginate(:page => page)
    end
  end

  def new
    @faculty.build_user
    @faculty.user.role = Role.faculty_role
  end

  def show
    @faculty = FacultiesDecorator.decorate(@faculty)
  end

  def create
    @faculty = Faculty.new(faculty_params)
    if @faculty.save
      flash.now[:success] = I18n.t :success, :scope => [:faculty, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:faculty, :create]
      render "new"
    end
  end

  def update
    if @faculty.update(faculty_update_params)
      @faculty.reload
      flash.now[:success] = I18n.t :success, :scope => [:faculty, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:faculty, :update]
      render "edit"
    end
  end

  def destroy
    if @faculty.destroy
      flash.now[:success] = I18n.t :success, :scope => [:faculty, :destroy]
      redirect_to faculties_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:faculty, :destroy]
      render "show"
    end
  end

  private

  def faculty_params
    fac_params = params.require(:faculty).permit(:name , :designation, :user_attributes => [:user_id, :email, :password, :password_confirmation, :role_id], :department_ids => [])
  end

  def faculty_update_params
    fac_params = params.require(:faculty).permit(:name , :designation, :department_ids => [])
  end

end
