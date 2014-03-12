class SearchController < ApplicationController
  skip_authorization_check

  def index
    return unless params[:global_search].present?
    search_results = PgSearch.multisearch(params[:global_search])
    users = []
    students = []
    faculties = []
    courses = []
    exams = []
    search_results.each do |item|
      if item.searchable_type == 'User'
        users << User.find(item.searchable_id)
      elsif item.searchable_type == 'Student'
        students << Student.find(item.searchable_id)
      elsif item.searchable_type == 'Faculty'
        faculties << Faculty.find(item.searchable_id)
      elsif item.searchable_type == 'Course'
        courses << Course.find(item.searchable_id)
      elsif item.searchable_type == 'Exam'
        exams << Exam.find(item.searchable_id)
      end
    end
    @grouped_results ={:users => users, :students => students, :faculties => faculties, :courses => courses, :exams => exams}
  end
end
