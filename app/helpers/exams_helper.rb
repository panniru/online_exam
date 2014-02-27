module ExamsHelper

  def exam_action_bar(exam)
    buttons = []
    buttons << edit_exam(exam)
    buttons << delete_exam(exam)
    buttons << question_btn_group(exam)
    content_tag(:div,raw(buttons.join(" ")))
  end

  def new_exam
    link_to "New Exam", new_exam_path, :class => "btn btn-primary"
  end

  def question_btn_group(exam)
    links = []
    links << link_to("Add Question", new_exam_multiple_choice_question_path(exam), :class => "btn btn-primary")
    links << link_to("Upload Multiple Choice Questions", upload_new_exam_multiple_choice_questions_path(exam))
    links << link_to("Upload Fill in The Blanks", upload_new_exam_descriptive_questions_path(exam))
    links << link_to("Show Multiple Choice Questions", exam_multiple_choice_questions_path(exam))
    links << descriptive_questions(exam)
    ApplicationHelper.btn_group(links)
  end

  private
  def edit_exam(exam)
    link_to "Edit", edit_exam_path(exam), :class => "btn btn-success"
  end

  def delete_exam(exam)
    link_to "Delete", exam, :class => "btn btn-danger", :data => { :confirm => 'Are You Sure ?', :method => :delete }
  end

  def descriptive_questions(exam)
    link_to "Fill in The Blanks Questions", exam_descriptive_questions_path(exam)
  end

end
