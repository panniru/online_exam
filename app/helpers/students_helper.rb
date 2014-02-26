module StudentsHelper
  def student_btn_group
    links = []
    links << link_to("Add Student", new_student_path, :class => "btn btn-primary")
    links << link_to("Upload Students", new_upload_students_path)
    ApplicationHelper.btn_group(links)
  end
end
