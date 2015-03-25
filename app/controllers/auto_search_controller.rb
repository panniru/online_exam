class AutoSearchController < ApplicationController
  skip_authorization_check

  autocomplete :user, :user_id, :full => true, :scopes => [:exam_ceter_roles]

  autocomplete :user, :user_info, :column_name => :user_id, :full => true, :scopes => [:admins]

  autocomplete :faculty, :name, :full => true, :extra_data => [:designation]

  autocomplete :course, :name, :full => true
  autocomplete :exam, :subject, :full => true
  autocomplete :exam, :exam_name, :full => true

  def autocomplete_student_roll_number
    where_clause = nil
    where_clause = "where exam_id = #{params[:exam_id]} AND schedule_date = '#{params[:schedule_date]}'" if params[:exam_id].present? and params[:schedule_date].present?

    students = Student.where("(lower(roll_number) ILIKE '%#{params[:term]}%') AND (id in (SELECT student_id from results where schedule_id in (SELECT id from schedules #{where_clause if where_clause.present?})))")
    render :json => students.map{ |student| {:id => student.id, :label => student.roll_number}}
  end

  def get_autocomplete_items(parameters)
    items = super(parameters)
  end

end
