module ApplicationLinks
  def results
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-th-list', 'Results', results_student_path(current_user.resource), controller.action_name == "results")
  end

  def roles
    Role.where(:role => 'admin').map{|role| [role.role, role.id]}
  end

  def courses
    Course.all.map{|course| [course.name, course.id]}
  end

  def exams
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-tasks', 'Exams', exams_path, (controller.controller_name == "exams" or controller.controller_name == "descriptive_questions" or controller.controller_name == "multiple_choice_questions"))
  end

  def home
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-home', 'Home', root_path, controller.controller_name == "home")
  end


  def course_details
    Struct.new(:icon, :item, :link, :is_active ).new('glyphicon glyphicon-book', 'Courses', courses_path, controller.controller_name == "courses")
  end

  def students
    Struct.new(:icon, :item, :link, :is_active ).new('glyphicon glyphicon-certificate', 'Students', students_path, controller.controller_name == "students")
  end

  def admin
    Struct.new(:icon, :item, :link, :is_active ).new('glyphicon glyphicon-tower', 'Admins', users_path, controller.controller_name == "users")
  end

  def faculty
    Struct.new(:icon, :item, :link, :is_active ).new('glyphicon glyphicon-star', 'Faculties', faculties_path, controller.controller_name == "faculties")
  end

  def user_management
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-user', 'Users', users_path, controller.controller_name == "")
  end

  def schedules
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-time', 'Schedule', schedules_path, controller.controller_name == "schedules")
  end

  def reports
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-file', 'Reports', reports_path, controller.controller_name == "reports")
  end

  def exam_results
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-th-list', 'Results', results_path, controller.controller_name == "results")
  end

  def promote
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-check', 'Promote', students_to_promote_students_path, controller.action_name == "students_to_promote")
  end

  def instructions
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-list-alt', 'Instructions', instructions_path, controller.controller_name == "instructions")
  end

end
