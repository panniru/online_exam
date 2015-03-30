class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user.present? and current_user.faculty?
      page = params[:page].present? ? params[:page] : 1
      @courses = []
      if current_user.resource.present?
        @courses = current_user.resource.courses.paginate(:page => page)
        render "courses/index"
      end
    end
  end

end
