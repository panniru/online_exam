class UsersController < ApplicationController
  load_resource :except => [:index, :create]
  authorize_resource

  def index
    if params[:search].present?
      @users = User.search(params[:search])
    else
      @users = User.admins
    end
  end

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash.now[:success] = I18n.t :success, :scope => [:user, :create]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:user, :create]
      render "new"
    end
  end

  def update
    if @user.update(user_params)
      flash.now[:success] = I18n.t :success, :scope => [:user, :update]
      render "show"
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:user, :update]
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_id, :name, :password, :password_confirmation, :role_id, :email)
  end
end
