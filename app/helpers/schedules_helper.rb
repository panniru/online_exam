module SchedulesHelper

  def faculty_courses
    a = [""]
    if current_user.admin?
      a.concat(Course.all.map {|c| [c.name, c.id] })
    else
      a.concat(FacultyCourse.belonging_to_faculty(current_user.resource.id).map {|c| [c.course.name, c.course_id] })
    end
  end

  def schedule_results
    result = Result.belongs_to_student_schedule(current_user.resource, @schedule).first 
    if result.present?
      ResultsDecorator.decorate(result)
    else
      nil
    end
  end

end
