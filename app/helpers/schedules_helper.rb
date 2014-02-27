module SchedulesHelper

  def faculty_courses(user)
    a = [""]
    a.concat(FacultyCourse.belonging_to_faculty(user).map {|c| [c.course.name, c.course_id] })
  end
end
