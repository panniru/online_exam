class RenameCourseIdToExamIdMultipleChoiceQuestions < ActiveRecord::Migration
  def change
    rename_column :multiple_choice_questions, :course_id, :exam_id
  end
end
