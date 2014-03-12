class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user.faculty?
      page = params[:page].present? ? params[:page] : 1
      @courses = current_user.resource.courses.paginate(:page => page)
      render "courses/index"
    end
  end

end
