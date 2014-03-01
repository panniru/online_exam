module ApplicationHelper

  def self.btn_group(links)
    btn_group = "<div class='btn-group'>"
    btn_group += "#{links[0] }"
    links.delete_at(0)
    btn_group += "<button type='button' class='btn btn-primary dropdown-toggle' data-toggle='dropdown'><span class='caret'></span><span class='sr-only'>Toggle Dropdown</span></button>"
    btn_group += "<ul class='dropdown-menu' role='menu>"
    btn_group += "<li></li>"
    btn_group += "<li class='divider'></li>"
    links.each do |link|
      btn_group += "<li>#{link}</li>"
      btn_group += "<li class='divider'></li>"
    end
    btn_group += "</ul>"
    btn_group += "</div>"
  end

  def flash_alert_class(key)
    key = 'danger' if key == :error or key == :alert
    alert_class = ["alert"]
    if key.to_s == "fail"
      alert_class << "alert-danger"
    elsif key == :notice
      alert_class << "alert-info"
    else
      alert_class << "alert-#{key}"
    end
    alert_class.join(" ")
  end

  def bread_crumbs
    list = []
    url_parts = request.fullpath[1, request.fullpath.length].split('/')
    url = ""
    url_parts.each do |part|
      url += "/#{part}"
      item = part.partition('?').first.titleize
      klass = url_parts.last == part ? 'active' : ''
      list << Struct.new(:item, :link, :klass).new( item, url, klass)
    end
    list
  end

  def navigation_list
    list = []
    if current_user.admin?
      list << home
      list << course_details
      list << user_management
      list << students
      list << faculty
    elsif current_user.faculty?
      list << home
      list << exams
      list << schedules
      #list << survey
    elsif current_user.student?
      list << schedules
      list << results
    end
    list
  end

  def results
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-th-list', 'Results', results_student_path(current_user.try(:resource_id)), controller.action_name == "results")
  end

  def roles
    Role.all.map{|role| [role.role, role.id]}
  end

  def courses
    Course.all.map{|course| [course.name, course.id]}
  end

  def exams
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-home', 'Exams', exams_path, controller.controller_name == "exams")
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

  def faculty
    Struct.new(:icon, :item, :link, :is_active ).new('glyphicon glyphicon-star', 'Faculties', faculties_path, controller.controller_name == "faculties")
  end

  def user_management
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-user', 'Users', users_path, controller.controller_name == "users")
  end

  def schedules
    Struct.new(:icon, :item, :link, :is_active).new('glyphicon glyphicon-tasks', 'Schedule', schedules_path, controller.controller_name == "schedules")
  end

end
