module SchedulesHelper

  def faculty_courses
    a = [""]
    if current_user.admin?
      a.concat(Course.all.map {|c| [c.name, c.id] })
    else
      a.concat(FacultyCourse.belonging_to_faculty(current_user.resource.id).map {|c| [c.course.name, c.course_id] })
    end
  end

end
