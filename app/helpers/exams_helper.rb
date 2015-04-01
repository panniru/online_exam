module ExamsHelper

  CRITERIAS = ["O", "A", "B", "C", "D", "E"]
  CRITERIA_VALUES = [80, 70, 60, 50, 40, 35]
  def exam_action_bar(exam)
    buttons = []
    buttons << edit_exam(exam)
    buttons << delete_exam(exam)
    buttons << instruction(exam) if current_user.faculty?
    buttons << question_btn_group(exam)
    content_tag(:div,raw(buttons.join(" ")))
  end

  def new_exam
    link_to "New Exam", new_exam_path, :class => "btn btn-primary"
  end

  def instruction(exam)
    link_to '<span class="glyphicon glyphicon-list-alt"></span> Instructions'.html_safe, instructions_path(:exam_id => exam.id), :class => "btn btn-info"
  end

  def question_btn_group(exam)
    links = []
    links << link_to("Add Question", new_exam_multiple_choice_question_path(exam), :class => "btn btn-primary")
    if exam.multiple_choice.present? and exam.multiple_choice > 0
      links << link_to("Show Multiple Choice Questions", exam_multiple_choice_questions_path(exam))
      links << link_to("Upload Multiple Choice Questions", upload_new_exam_multiple_choice_questions_path(exam))
    end
    if exam.fill_in_blanks.present? and exam.fill_in_blanks > 0
      links << descriptive_questions(exam)
      links << link_to("Upload Fill in The Blanks", upload_new_exam_descriptive_questions_path(exam))
    end
    if exam.audio_questions.present? and exam.audio_questions > 0
      links << link_to("Add Audio Question", new_exam_audio_video_question_master_path(exam, :question_type => :audio))
      links << link_to("Show Audio Questions", exam_audio_video_question_masters_path(exam, :question_type=> "audio"))
    end
    if exam.video_questions.present? and exam.video_questions > 0
      links << link_to("Add video Question", new_exam_audio_video_question_master_path(exam, :question_type => :video))
      links << link_to("Show Video  Questions", exam_audio_video_question_masters_path(exam, :question_type=> "video"))
    end
    ApplicationHelper.btn_group(links)
  end

  def right_option_for_answer(question)
    if question.option_1.to_s == question.answer.to_s
      return "option_1"
    elsif question.option_2.to_s == question.answer.to_s
      return "option_2"
    elsif question.option_3.to_s == question.answer.to_s
      return "option_3"
    elsif question.option_4.to_s == question.answer.to_s
      return "option_4"
    end
  end

  private
  def edit_exam(exam)
    link_to "Edit", edit_exam_path(exam), :class => "btn btn-success"
  end

  def delete_exam(exam)
    link_to "Delete", exam, :class => "btn btn-danger", :data => { :confirm => 'Are You Sure ?', :method => :delete }
  end

  def descriptive_questions(exam)
    link_to "Show Fill in The Blanks Questions", exam_descriptive_questions_path(exam)
  end

end
