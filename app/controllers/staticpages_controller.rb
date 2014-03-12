class StaticpagesController < ApplicationController
  skip_authorization_check

  def course_management
    format_to_js
  end

  def exam_management
    format_to_js
  end

  def student_management
    format_to_js
  end

  def faculty_management
    format_to_js
  end

  def online_exam
    format_to_js
  end

  def reporting
    format_to_js
  end

  private
  def format_to_js
    respond_to do |format|
      format.js {}
    end
  end

end
