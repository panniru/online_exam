class FacultiesDecorator < Draper::Decorator
  delegate_all

  def course_names
    courses.map{|c| c.name}.join(", ")
  end

end
